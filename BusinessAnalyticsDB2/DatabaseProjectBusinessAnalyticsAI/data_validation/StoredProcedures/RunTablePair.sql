CREATE PROCEDURE [data_validation].[RunTablePair]
    @ValidationCode NVARCHAR(128),
    @ExecutedBy NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE
        @TablePairId INT,
        @LeftSchemaName SYSNAME,
        @LeftTableName SYSNAME,
        @RightSchemaName SYSNAME,
        @RightTableName SYSNAME,
        @LeftQualified NVARCHAR(300),
        @RightQualified NVARCHAR(300),
        @RunId BIGINT,
        @ResultId BIGINT,
        @RuleCode NVARCHAR(50),
        @SampleLimit INT,
        @LeftObjectId INT,
        @RightObjectId INT,
        @Sql NVARCHAR(MAX),
        @IssueCount BIGINT,
        @LeftMetric NVARCHAR(200),
        @RightMetric NVARCHAR(200),
        @SummaryText NVARCHAR(1000),
        @PartitionLeftExpr NVARCHAR(MAX),
        @PartitionRightExpr NVARCHAR(MAX),
        @BusinessLeftExpr NVARCHAR(MAX),
        @BusinessRightExpr NVARCHAR(MAX),
        @AllLeftExpr NVARCHAR(MAX),
        @AllRightExpr NVARCHAR(MAX),
        @LeftScopePredicate NVARCHAR(MAX),
        @RightScopePredicate NVARCHAR(MAX),
        @LeftBaseFrom NVARCHAR(MAX),
        @RightBaseFrom NVARCHAR(MAX),
        @ErrorMessage NVARCHAR(MAX);

    SELECT
        @TablePairId = tp.[TablePairId],
        @LeftSchemaName = tp.[LeftSchemaName],
        @LeftTableName = tp.[LeftTableName],
        @RightSchemaName = tp.[RightSchemaName],
        @RightTableName = tp.[RightTableName]
    FROM [data_validation].[TablePair] AS tp
    WHERE tp.[ValidationCode] = @ValidationCode
      AND tp.[IsActive] = 1;

    IF @TablePairId IS NULL
    BEGIN
        THROW 51000, 'ValidationCode was not found in data_validation.TablePair.', 0;
    END;

    SET @LeftQualified = QUOTENAME(@LeftSchemaName) + N'.' + QUOTENAME(@LeftTableName);
    SET @RightQualified = QUOTENAME(@RightSchemaName) + N'.' + QUOTENAME(@RightTableName);
    SET @LeftObjectId = OBJECT_ID(@LeftQualified);
    SET @RightObjectId = OBJECT_ID(@RightQualified);

    INSERT INTO [data_validation].[Run]
    (
        [TablePairId],
        [ValidationCode],
        [ExecutedBy]
    )
    VALUES
    (
        @TablePairId,
        @ValidationCode,
        @ExecutedBy
    );

    SET @RunId = SCOPE_IDENTITY();

    BEGIN TRY
        CREATE TABLE [#Rules]
        (
            [RuleCode] NVARCHAR(50) NOT NULL PRIMARY KEY,
            [SampleLimit] INT NOT NULL
        );

        INSERT INTO [#Rules]
        (
            [RuleCode],
            [SampleLimit]
        )
        SELECT
            r.[RuleCode],
            r.[SampleLimit]
        FROM [data_validation].[Rule] AS r
        WHERE r.[TablePairId] = @TablePairId
          AND r.[IsActive] = 1;

        CREATE TABLE [#Keys]
        (
            [KeyOrdinal] INT NOT NULL,
            [KeyRole] NVARCHAR(30) NOT NULL,
            [LeftExpression] NVARCHAR(2000) NOT NULL,
            [RightExpression] NVARCHAR(2000) NOT NULL
        );

        INSERT INTO [#Keys]
        (
            [KeyOrdinal],
            [KeyRole],
            [LeftExpression],
            [RightExpression]
        )
        SELECT
            tk.[KeyOrdinal],
            tk.[KeyRole],
            tk.[LeftExpression],
            tk.[RightExpression]
        FROM [data_validation].[TableKey] AS tk
        WHERE tk.[TablePairId] = @TablePairId
          AND tk.[IsActive] = 1
        ORDER BY tk.[KeyOrdinal];

        IF NOT EXISTS (SELECT 1 FROM [#Keys] WHERE [KeyRole] = N'PARTITION')
        BEGIN
            THROW 51000, 'At least one PARTITION key is required in data_validation.TableKey.', 0;
        END;

        IF NOT EXISTS (SELECT 1 FROM [#Keys] WHERE [KeyRole] = N'BUSINESS')
        BEGIN
            THROW 51000, 'At least one BUSINESS key is required in data_validation.TableKey.', 0;
        END;

        SELECT
            @PartitionLeftExpr =
                CASE
                    WHEN COUNT(*) = 1 THEN MIN(REPLACE([LeftExpression], N'{alias}', N'l'))
                    ELSE N'CONCAT_WS(N''|'', ' + STRING_AGG(REPLACE([LeftExpression], N'{alias}', N'l'), N', ') + N')'
                END,
            @PartitionRightExpr =
                CASE
                    WHEN COUNT(*) = 1 THEN MIN(REPLACE([RightExpression], N'{alias}', N'r'))
                    ELSE N'CONCAT_WS(N''|'', ' + STRING_AGG(REPLACE([RightExpression], N'{alias}', N'r'), N', ') + N')'
                END
        FROM [#Keys]
        WHERE [KeyRole] = N'PARTITION';

        SELECT
            @BusinessLeftExpr =
                CASE
                    WHEN COUNT(*) = 1 THEN MIN(REPLACE([LeftExpression], N'{alias}', N'l'))
                    ELSE N'CONCAT_WS(N''|'', ' + STRING_AGG(REPLACE([LeftExpression], N'{alias}', N'l'), N', ') + N')'
                END,
            @BusinessRightExpr =
                CASE
                    WHEN COUNT(*) = 1 THEN MIN(REPLACE([RightExpression], N'{alias}', N'r'))
                    ELSE N'CONCAT_WS(N''|'', ' + STRING_AGG(REPLACE([RightExpression], N'{alias}', N'r'), N', ') + N')'
                END
        FROM [#Keys]
        WHERE [KeyRole] = N'BUSINESS';

        SELECT
            @AllLeftExpr =
                CASE
                    WHEN COUNT(*) = 1 THEN MIN(REPLACE([LeftExpression], N'{alias}', N'l'))
                    ELSE N'CONCAT_WS(N''|'', ' + STRING_AGG(REPLACE([LeftExpression], N'{alias}', N'l'), N', ') + N')'
                END,
            @AllRightExpr =
                CASE
                    WHEN COUNT(*) = 1 THEN MIN(REPLACE([RightExpression], N'{alias}', N'r'))
                    ELSE N'CONCAT_WS(N''|'', ' + STRING_AGG(REPLACE([RightExpression], N'{alias}', N'r'), N', ') + N')'
                END
        FROM [#Keys];

        CREATE TABLE [#IncludedCompanies]
        (
            [CompanyId] NVARCHAR(100) NOT NULL PRIMARY KEY
        );

        CREATE TABLE [#ExcludedCompanies]
        (
            [CompanyId] NVARCHAR(100) NOT NULL PRIMARY KEY
        );

        INSERT INTO [#IncludedCompanies]
        (
            [CompanyId]
        )
        SELECT cs.[CompanyId]
        FROM [data_validation].[CompanyScope] AS cs
        WHERE cs.[TablePairId] = @TablePairId
          AND cs.[ScopeType] = N'INCLUDE'
          AND cs.[IsActive] = 1;

        INSERT INTO [#ExcludedCompanies]
        (
            [CompanyId]
        )
        SELECT cs.[CompanyId]
        FROM [data_validation].[CompanyScope] AS cs
        WHERE cs.[TablePairId] = @TablePairId
          AND cs.[ScopeType] = N'EXCLUDE'
          AND cs.[IsActive] = 1;

        SET @LeftScopePredicate = N'1 = 1';
        SET @RightScopePredicate = N'1 = 1';

        IF EXISTS (SELECT 1 FROM [#IncludedCompanies])
        BEGIN
            SET @LeftScopePredicate = @LeftScopePredicate + N' AND CONVERT(NVARCHAR(100), ' + @PartitionLeftExpr + N') IN (SELECT [CompanyId] FROM [#IncludedCompanies])';
            SET @RightScopePredicate = @RightScopePredicate + N' AND CONVERT(NVARCHAR(100), ' + @PartitionRightExpr + N') IN (SELECT [CompanyId] FROM [#IncludedCompanies])';
        END;

        IF EXISTS (SELECT 1 FROM [#ExcludedCompanies])
        BEGIN
            SET @LeftScopePredicate = @LeftScopePredicate + N' AND CONVERT(NVARCHAR(100), ' + @PartitionLeftExpr + N') NOT IN (SELECT [CompanyId] FROM [#ExcludedCompanies])';
            SET @RightScopePredicate = @RightScopePredicate + N' AND CONVERT(NVARCHAR(100), ' + @PartitionRightExpr + N') NOT IN (SELECT [CompanyId] FROM [#ExcludedCompanies])';
        END;

        SET @LeftBaseFrom = @LeftQualified + N' AS l WHERE ' + @LeftScopePredicate;
        SET @RightBaseFrom = @RightQualified + N' AS r WHERE ' + @RightScopePredicate;

        IF EXISTS (SELECT 1 FROM [#Rules] WHERE [RuleCode] = N'TABLE_EXISTS')
        BEGIN
            INSERT INTO [data_validation].[Result]
            (
                [RunId],
                [RuleCode],
                [ResultStatus],
                [IssueCount],
                [LeftMetricValue],
                [RightMetricValue],
                [SummaryText]
            )
            VALUES
            (
                @RunId,
                N'TABLE_EXISTS',
                CASE WHEN @LeftObjectId IS NOT NULL AND @RightObjectId IS NOT NULL THEN N'PASS' ELSE N'FAIL' END,
                CASE WHEN @LeftObjectId IS NOT NULL AND @RightObjectId IS NOT NULL THEN 0 ELSE 1 END,
                @LeftQualified,
                @RightQualified,
                CASE WHEN @LeftObjectId IS NOT NULL AND @RightObjectId IS NOT NULL THEN N'Both tables exist.' ELSE N'One or both tables do not exist.' END
            );
        END;

        IF @LeftObjectId IS NULL OR @RightObjectId IS NULL
        BEGIN
            UPDATE [data_validation].[Run]
            SET
                [FinishedAt] = SYSDATETIMEOFFSET(),
                [ExecutionStatus] = N'FAILED',
                [Message] = N'Table existence check failed.'
            WHERE [RunId] = @RunId;

            RETURN;
        END;

        DECLARE RuleCursor CURSOR LOCAL FAST_FORWARD FOR
            SELECT [RuleCode], [SampleLimit]
            FROM [#Rules]
            WHERE [RuleCode] <> N'TABLE_EXISTS'
            ORDER BY [RuleCode];

        OPEN RuleCursor;
        FETCH NEXT FROM RuleCursor INTO @RuleCode, @SampleLimit;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @IssueCount = 0;
            SET @LeftMetric = NULL;
            SET @RightMetric = NULL;
            SET @SummaryText = NULL;

            IF @RuleCode = N'ROWCOUNT_TOTAL'
            BEGIN
                SET @Sql = N'
                SELECT
                    @LeftMetricOut = CONVERT(NVARCHAR(200), (SELECT COUNT_BIG(1) FROM ' + @LeftBaseFrom + N')),
                    @RightMetricOut = CONVERT(NVARCHAR(200), (SELECT COUNT_BIG(1) FROM ' + @RightBaseFrom + N'));
                SET @IssueCountOut = CASE WHEN @LeftMetricOut = @RightMetricOut THEN 0 ELSE 1 END;';

                EXEC sys.sp_executesql
                    @Sql,
                    N'@IssueCountOut BIGINT OUTPUT, @LeftMetricOut NVARCHAR(200) OUTPUT, @RightMetricOut NVARCHAR(200) OUTPUT',
                    @IssueCountOut = @IssueCount OUTPUT,
                    @LeftMetricOut = @LeftMetric OUTPUT,
                    @RightMetricOut = @RightMetric OUTPUT;

                SET @SummaryText = N'Compares total row count between left and right tables.';
            END;
            ELSE IF @RuleCode = N'ROWCOUNT_BY_COMPANY'
            BEGIN
                SET @Sql = N'
                WITH LeftCounts AS
                (
                    SELECT ' + @PartitionLeftExpr + N' AS [CompanyId], COUNT_BIG(1) AS [RowCount]
                    FROM ' + @LeftBaseFrom + N'
                    GROUP BY ' + @PartitionLeftExpr + N'
                ),
                RightCounts AS
                (
                    SELECT ' + @PartitionRightExpr + N' AS [CompanyId], COUNT_BIG(1) AS [RowCount]
                    FROM ' + @RightBaseFrom + N'
                    GROUP BY ' + @PartitionRightExpr + N'
                )
                SELECT
                    @IssueCountOut = COUNT_BIG(1),
                    @LeftMetricOut = CONVERT(NVARCHAR(200), (SELECT COUNT_BIG(1) FROM LeftCounts)),
                    @RightMetricOut = CONVERT(NVARCHAR(200), (SELECT COUNT_BIG(1) FROM RightCounts))
                FROM
                (
                    SELECT
                        COALESCE(lc.[CompanyId], rc.[CompanyId]) AS [CompanyId],
                        lc.[RowCount] AS [LeftCount],
                        rc.[RowCount] AS [RightCount]
                    FROM LeftCounts AS lc
                    FULL OUTER JOIN RightCounts AS rc
                        ON lc.[CompanyId] = rc.[CompanyId]
                    WHERE ISNULL(lc.[RowCount], -1) <> ISNULL(rc.[RowCount], -1)
                ) AS Mismatch;';

                EXEC sys.sp_executesql
                    @Sql,
                    N'@IssueCountOut BIGINT OUTPUT, @LeftMetricOut NVARCHAR(200) OUTPUT, @RightMetricOut NVARCHAR(200) OUTPUT',
                    @IssueCountOut = @IssueCount OUTPUT,
                    @LeftMetricOut = @LeftMetric OUTPUT,
                    @RightMetricOut = @RightMetric OUTPUT;

                SET @SummaryText = N'Compares row count per CompanyId.';
            END;
            ELSE IF @RuleCode = N'DISTINCT_KEYCOUNT_BY_COMPANY'
            BEGIN
                SET @Sql = N'
                WITH LeftCounts AS
                (
                    SELECT ' + @PartitionLeftExpr + N' AS [CompanyId], COUNT(DISTINCT ' + @BusinessLeftExpr + N') AS [DistinctKeyCount]
                    FROM ' + @LeftBaseFrom + N'
                    GROUP BY ' + @PartitionLeftExpr + N'
                ),
                RightCounts AS
                (
                    SELECT ' + @PartitionRightExpr + N' AS [CompanyId], COUNT(DISTINCT ' + @BusinessRightExpr + N') AS [DistinctKeyCount]
                    FROM ' + @RightBaseFrom + N'
                    GROUP BY ' + @PartitionRightExpr + N'
                )
                SELECT
                    @IssueCountOut = COUNT_BIG(1),
                    @LeftMetricOut = CONVERT(NVARCHAR(200), (SELECT ISNULL(SUM([DistinctKeyCount]), 0) FROM LeftCounts)),
                    @RightMetricOut = CONVERT(NVARCHAR(200), (SELECT ISNULL(SUM([DistinctKeyCount]), 0) FROM RightCounts))
                FROM
                (
                    SELECT
                        COALESCE(lc.[CompanyId], rc.[CompanyId]) AS [CompanyId],
                        lc.[DistinctKeyCount] AS [LeftCount],
                        rc.[DistinctKeyCount] AS [RightCount]
                    FROM LeftCounts AS lc
                    FULL OUTER JOIN RightCounts AS rc
                        ON lc.[CompanyId] = rc.[CompanyId]
                    WHERE ISNULL(lc.[DistinctKeyCount], -1) <> ISNULL(rc.[DistinctKeyCount], -1)
                ) AS Mismatch;';

                EXEC sys.sp_executesql
                    @Sql,
                    N'@IssueCountOut BIGINT OUTPUT, @LeftMetricOut NVARCHAR(200) OUTPUT, @RightMetricOut NVARCHAR(200) OUTPUT',
                    @IssueCountOut = @IssueCount OUTPUT,
                    @LeftMetricOut = @LeftMetric OUTPUT,
                    @RightMetricOut = @RightMetric OUTPUT;

                SET @SummaryText = N'Compares distinct business key count per CompanyId.';
            END;
            ELSE IF @RuleCode = N'DUPLICATE_KEYS_LEFT'
            BEGIN
                SET @Sql = N'
                SELECT
                    @IssueCountOut = COUNT_BIG(1),
                    @LeftMetricOut = CONVERT(NVARCHAR(200), ISNULL(SUM([DuplicateCount]), 0))
                FROM
                (
                    SELECT COUNT_BIG(1) AS [DuplicateCount]
                    FROM ' + @LeftBaseFrom + N'
                    GROUP BY ' + @PartitionLeftExpr + N', ' + @BusinessLeftExpr + N'
                    HAVING COUNT_BIG(1) > 1
                ) AS Duplicates;';

                EXEC sys.sp_executesql
                    @Sql,
                    N'@IssueCountOut BIGINT OUTPUT, @LeftMetricOut NVARCHAR(200) OUTPUT',
                    @IssueCountOut = @IssueCount OUTPUT,
                    @LeftMetricOut = @LeftMetric OUTPUT;

                SET @SummaryText = N'Finds duplicate business keys in left table.';
            END;
            ELSE IF @RuleCode = N'DUPLICATE_KEYS_RIGHT'
            BEGIN
                SET @Sql = N'
                SELECT
                    @IssueCountOut = COUNT_BIG(1),
                    @RightMetricOut = CONVERT(NVARCHAR(200), ISNULL(SUM([DuplicateCount]), 0))
                FROM
                (
                    SELECT COUNT_BIG(1) AS [DuplicateCount]
                    FROM ' + @RightBaseFrom + N'
                    GROUP BY ' + @PartitionRightExpr + N', ' + @BusinessRightExpr + N'
                    HAVING COUNT_BIG(1) > 1
                ) AS Duplicates;';

                EXEC sys.sp_executesql
                    @Sql,
                    N'@IssueCountOut BIGINT OUTPUT, @RightMetricOut NVARCHAR(200) OUTPUT',
                    @IssueCountOut = @IssueCount OUTPUT,
                    @RightMetricOut = @RightMetric OUTPUT;

                SET @SummaryText = N'Finds duplicate business keys in right table.';
            END;
            ELSE IF @RuleCode = N'MISSING_IN_RIGHT'
            BEGIN
                SET @Sql = N'
                WITH LeftKeys AS
                (
                    SELECT DISTINCT ' + @AllLeftExpr + N' AS [FullKey]
                    FROM ' + @LeftBaseFrom + N'
                ),
                RightKeys AS
                (
                    SELECT DISTINCT ' + @AllRightExpr + N' AS [FullKey]
                    FROM ' + @RightBaseFrom + N'
                )
                SELECT @IssueCountOut = COUNT_BIG(1)
                FROM LeftKeys AS lk
                LEFT JOIN RightKeys AS rk
                    ON rk.[FullKey] = lk.[FullKey]
                WHERE rk.[FullKey] IS NULL;';

                EXEC sys.sp_executesql
                    @Sql,
                    N'@IssueCountOut BIGINT OUTPUT',
                    @IssueCountOut = @IssueCount OUTPUT;

                SET @SummaryText = N'Finds keys present in left table but missing in right table.';
            END;
            ELSE IF @RuleCode = N'MISSING_IN_LEFT'
            BEGIN
                SET @Sql = N'
                WITH LeftKeys AS
                (
                    SELECT DISTINCT ' + @AllLeftExpr + N' AS [FullKey]
                    FROM ' + @LeftBaseFrom + N'
                ),
                RightKeys AS
                (
                    SELECT DISTINCT ' + @AllRightExpr + N' AS [FullKey]
                    FROM ' + @RightBaseFrom + N'
                )
                SELECT @IssueCountOut = COUNT_BIG(1)
                FROM RightKeys AS rk
                LEFT JOIN LeftKeys AS lk
                    ON lk.[FullKey] = rk.[FullKey]
                WHERE lk.[FullKey] IS NULL;';

                EXEC sys.sp_executesql
                    @Sql,
                    N'@IssueCountOut BIGINT OUTPUT',
                    @IssueCountOut = @IssueCount OUTPUT;

                SET @SummaryText = N'Finds keys present in right table but missing in left table.';
            END;

            INSERT INTO [data_validation].[Result]
            (
                [RunId],
                [RuleCode],
                [ResultStatus],
                [IssueCount],
                [LeftMetricValue],
                [RightMetricValue],
                [SummaryText]
            )
            VALUES
            (
                @RunId,
                @RuleCode,
                CASE WHEN ISNULL(@IssueCount, 0) = 0 THEN N'PASS' ELSE N'FAIL' END,
                ISNULL(@IssueCount, 0),
                @LeftMetric,
                @RightMetric,
                @SummaryText
            );

            SET @ResultId = SCOPE_IDENTITY();

            IF ISNULL(@IssueCount, 0) > 0
            BEGIN
                IF @RuleCode = N'ROWCOUNT_BY_COMPANY'
                BEGIN
                    SET @Sql = N'
                    WITH LeftCounts AS
                    (
                        SELECT ' + @PartitionLeftExpr + N' AS [CompanyId], COUNT_BIG(1) AS [RowCount]
                        FROM ' + @LeftBaseFrom + N'
                        GROUP BY ' + @PartitionLeftExpr + N'
                    ),
                    RightCounts AS
                    (
                        SELECT ' + @PartitionRightExpr + N' AS [CompanyId], COUNT_BIG(1) AS [RowCount]
                        FROM ' + @RightBaseFrom + N'
                        GROUP BY ' + @PartitionRightExpr + N'
                    )
                    INSERT INTO [data_validation].[ResultSample]
                    (
                        [ResultId],
                        [SampleType],
                        [CompanyId],
                        [LeftValue],
                        [RightValue],
                        [Details]
                    )
                    SELECT TOP (@SampleLimit)
                        @ResultId,
                        N''ROWCOUNT_BY_COMPANY'',
                        CONVERT(NVARCHAR(100), COALESCE(lc.[CompanyId], rc.[CompanyId])),
                        CONVERT(NVARCHAR(1000), lc.[RowCount]),
                        CONVERT(NVARCHAR(1000), rc.[RowCount]),
                        N''Company-level row count mismatch''
                    FROM LeftCounts AS lc
                    FULL OUTER JOIN RightCounts AS rc
                        ON lc.[CompanyId] = rc.[CompanyId]
                    WHERE ISNULL(lc.[RowCount], -1) <> ISNULL(rc.[RowCount], -1)
                    ORDER BY COALESCE(lc.[CompanyId], rc.[CompanyId]);';

                    EXEC sys.sp_executesql
                        @Sql,
                        N'@ResultId BIGINT, @SampleLimit INT',
                        @ResultId = @ResultId,
                        @SampleLimit = @SampleLimit;
                END;
                ELSE IF @RuleCode = N'DISTINCT_KEYCOUNT_BY_COMPANY'
                BEGIN
                    SET @Sql = N'
                    WITH LeftCounts AS
                    (
                        SELECT ' + @PartitionLeftExpr + N' AS [CompanyId], COUNT(DISTINCT ' + @BusinessLeftExpr + N') AS [DistinctKeyCount]
                        FROM ' + @LeftBaseFrom + N'
                        GROUP BY ' + @PartitionLeftExpr + N'
                    ),
                    RightCounts AS
                    (
                        SELECT ' + @PartitionRightExpr + N' AS [CompanyId], COUNT(DISTINCT ' + @BusinessRightExpr + N') AS [DistinctKeyCount]
                        FROM ' + @RightBaseFrom + N'
                        GROUP BY ' + @PartitionRightExpr + N'
                    )
                    INSERT INTO [data_validation].[ResultSample]
                    (
                        [ResultId],
                        [SampleType],
                        [CompanyId],
                        [LeftValue],
                        [RightValue],
                        [Details]
                    )
                    SELECT TOP (@SampleLimit)
                        @ResultId,
                        N''DISTINCT_KEYCOUNT_BY_COMPANY'',
                        CONVERT(NVARCHAR(100), COALESCE(lc.[CompanyId], rc.[CompanyId])),
                        CONVERT(NVARCHAR(1000), lc.[DistinctKeyCount]),
                        CONVERT(NVARCHAR(1000), rc.[DistinctKeyCount]),
                        N''Company-level distinct key count mismatch''
                    FROM LeftCounts AS lc
                    FULL OUTER JOIN RightCounts AS rc
                        ON lc.[CompanyId] = rc.[CompanyId]
                    WHERE ISNULL(lc.[DistinctKeyCount], -1) <> ISNULL(rc.[DistinctKeyCount], -1)
                    ORDER BY COALESCE(lc.[CompanyId], rc.[CompanyId]);';

                    EXEC sys.sp_executesql
                        @Sql,
                        N'@ResultId BIGINT, @SampleLimit INT',
                        @ResultId = @ResultId,
                        @SampleLimit = @SampleLimit;
                END;
                ELSE IF @RuleCode = N'DUPLICATE_KEYS_LEFT'
                BEGIN
                    SET @Sql = N'
                    INSERT INTO [data_validation].[ResultSample]
                    (
                        [ResultId],
                        [SampleType],
                        [CompanyId],
                        [BusinessKey],
                        [LeftValue],
                        [Details]
                    )
                    SELECT TOP (@SampleLimit)
                        @ResultId,
                        N''DUPLICATE_KEYS_LEFT'',
                        CONVERT(NVARCHAR(100), ' + @PartitionLeftExpr + N'),
                        CONVERT(NVARCHAR(500), ' + @BusinessLeftExpr + N'),
                        CONVERT(NVARCHAR(1000), COUNT_BIG(1)),
                        N''Duplicate business key group in left table''
                    FROM ' + @LeftBaseFrom + N'
                    GROUP BY ' + @PartitionLeftExpr + N', ' + @BusinessLeftExpr + N'
                    HAVING COUNT_BIG(1) > 1
                    ORDER BY CONVERT(NVARCHAR(100), ' + @PartitionLeftExpr + N'), CONVERT(NVARCHAR(500), ' + @BusinessLeftExpr + N');';

                    EXEC sys.sp_executesql
                        @Sql,
                        N'@ResultId BIGINT, @SampleLimit INT',
                        @ResultId = @ResultId,
                        @SampleLimit = @SampleLimit;
                END;
                ELSE IF @RuleCode = N'DUPLICATE_KEYS_RIGHT'
                BEGIN
                    SET @Sql = N'
                    INSERT INTO [data_validation].[ResultSample]
                    (
                        [ResultId],
                        [SampleType],
                        [CompanyId],
                        [BusinessKey],
                        [RightValue],
                        [Details]
                    )
                    SELECT TOP (@SampleLimit)
                        @ResultId,
                        N''DUPLICATE_KEYS_RIGHT'',
                        CONVERT(NVARCHAR(100), ' + @PartitionRightExpr + N'),
                        CONVERT(NVARCHAR(500), ' + @BusinessRightExpr + N'),
                        CONVERT(NVARCHAR(1000), COUNT_BIG(1)),
                        N''Duplicate business key group in right table''
                    FROM ' + @RightBaseFrom + N'
                    GROUP BY ' + @PartitionRightExpr + N', ' + @BusinessRightExpr + N'
                    HAVING COUNT_BIG(1) > 1
                    ORDER BY CONVERT(NVARCHAR(100), ' + @PartitionRightExpr + N'), CONVERT(NVARCHAR(500), ' + @BusinessRightExpr + N');';

                    EXEC sys.sp_executesql
                        @Sql,
                        N'@ResultId BIGINT, @SampleLimit INT',
                        @ResultId = @ResultId,
                        @SampleLimit = @SampleLimit;
                END;
                ELSE IF @RuleCode = N'MISSING_IN_RIGHT'
                BEGIN
                    SET @Sql = N'
                    WITH LeftKeys AS
                    (
                        SELECT DISTINCT
                            ' + @PartitionLeftExpr + N' AS [CompanyId],
                            ' + @BusinessLeftExpr + N' AS [BusinessKey],
                            ' + @AllLeftExpr + N' AS [FullKey]
                        FROM ' + @LeftBaseFrom + N'
                    ),
                    RightKeys AS
                    (
                        SELECT DISTINCT
                            ' + @AllRightExpr + N' AS [FullKey]
                        FROM ' + @RightBaseFrom + N'
                    )
                    INSERT INTO [data_validation].[ResultSample]
                    (
                        [ResultId],
                        [SampleType],
                        [CompanyId],
                        [BusinessKey],
                        [LeftValue],
                        [Details]
                    )
                    SELECT TOP (@SampleLimit)
                        @ResultId,
                        N''MISSING_IN_RIGHT'',
                        CONVERT(NVARCHAR(100), lk.[CompanyId]),
                        CONVERT(NVARCHAR(500), lk.[BusinessKey]),
                        CONVERT(NVARCHAR(1000), lk.[FullKey]),
                        N''Key exists in left table but not in right table''
                    FROM LeftKeys AS lk
                    LEFT JOIN RightKeys AS rk
                        ON rk.[FullKey] = lk.[FullKey]
                    WHERE rk.[FullKey] IS NULL
                    ORDER BY lk.[CompanyId], lk.[BusinessKey];';

                    EXEC sys.sp_executesql
                        @Sql,
                        N'@ResultId BIGINT, @SampleLimit INT',
                        @ResultId = @ResultId,
                        @SampleLimit = @SampleLimit;
                END;
                ELSE IF @RuleCode = N'MISSING_IN_LEFT'
                BEGIN
                    SET @Sql = N'
                    WITH LeftKeys AS
                    (
                        SELECT DISTINCT
                            ' + @AllLeftExpr + N' AS [FullKey]
                        FROM ' + @LeftBaseFrom + N'
                    ),
                    RightKeys AS
                    (
                        SELECT DISTINCT
                            ' + @PartitionRightExpr + N' AS [CompanyId],
                            ' + @BusinessRightExpr + N' AS [BusinessKey],
                            ' + @AllRightExpr + N' AS [FullKey]
                        FROM ' + @RightBaseFrom + N'
                    )
                    INSERT INTO [data_validation].[ResultSample]
                    (
                        [ResultId],
                        [SampleType],
                        [CompanyId],
                        [BusinessKey],
                        [RightValue],
                        [Details]
                    )
                    SELECT TOP (@SampleLimit)
                        @ResultId,
                        N''MISSING_IN_LEFT'',
                        CONVERT(NVARCHAR(100), rk.[CompanyId]),
                        CONVERT(NVARCHAR(500), rk.[BusinessKey]),
                        CONVERT(NVARCHAR(1000), rk.[FullKey]),
                        N''Key exists in right table but not in left table''
                    FROM RightKeys AS rk
                    LEFT JOIN LeftKeys AS lk
                        ON lk.[FullKey] = rk.[FullKey]
                    WHERE lk.[FullKey] IS NULL
                    ORDER BY rk.[CompanyId], rk.[BusinessKey];';

                    EXEC sys.sp_executesql
                        @Sql,
                        N'@ResultId BIGINT, @SampleLimit INT',
                        @ResultId = @ResultId,
                        @SampleLimit = @SampleLimit;
                END;
            END;

            FETCH NEXT FROM RuleCursor INTO @RuleCode, @SampleLimit;
        END;

        CLOSE RuleCursor;
        DEALLOCATE RuleCursor;

        UPDATE [data_validation].[Run]
        SET
            [FinishedAt] = SYSDATETIMEOFFSET(),
            [ExecutionStatus] = CASE
                                    WHEN EXISTS
                                    (
                                        SELECT 1
                                        FROM [data_validation].[Result] AS res
                                        WHERE res.[RunId] = @RunId
                                          AND res.[ResultStatus] IN (N'FAIL', N'ERROR')
                                    ) THEN N'FAILED'
                                    ELSE N'PASSED'
                                END,
            [Message] = N'Validation completed.'
        WHERE [RunId] = @RunId;
    END TRY
    BEGIN CATCH
        IF CURSOR_STATUS('local', 'RuleCursor') >= -1
        BEGIN
            CLOSE RuleCursor;
            DEALLOCATE RuleCursor;
        END;

        SET @ErrorMessage = ERROR_MESSAGE();

        UPDATE [data_validation].[Run]
        SET
            [FinishedAt] = SYSDATETIMEOFFSET(),
            [ExecutionStatus] = N'ERROR',
            [Message] = @ErrorMessage
        WHERE [RunId] = @RunId;

        THROW;
    END CATCH;
END


GO
