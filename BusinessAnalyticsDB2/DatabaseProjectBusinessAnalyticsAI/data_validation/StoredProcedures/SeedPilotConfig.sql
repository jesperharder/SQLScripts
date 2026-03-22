CREATE PROCEDURE [data_validation].[SeedPilotConfig]
AS
BEGIN
    SET NOCOUNT ON;

    MERGE [data_validation].[TablePair] AS tgt
    USING
    (
        SELECT N'STG.Customer' AS [ValidationCode], N'STG' AS [ValidationGroup], N'stg_bc' AS [LeftSchemaName], N'Customer' AS [LeftTableName], N'stg_bc_api' AS [RightSchemaName], N'Customer' AS [RightTableName], N'Legacy BC customer staging versus BC API customer staging' AS [Description]
        UNION ALL
        SELECT N'STG.Item', N'STG', N'stg_bc', N'Item', N'stg_bc_api', N'Item', N'Legacy BC item staging versus BC API item staging'
        UNION ALL
        SELECT N'DIM.Customer', N'DIM', N'dim', N'Customer', N'dim_v1', N'Customer', N'Legacy customer dimension versus v1 customer dimension'
    ) AS src
        ON tgt.[ValidationCode] = src.[ValidationCode]
    WHEN MATCHED THEN
        UPDATE SET
            [ValidationGroup] = src.[ValidationGroup],
            [LeftSchemaName] = src.[LeftSchemaName],
            [LeftTableName] = src.[LeftTableName],
            [RightSchemaName] = src.[RightSchemaName],
            [RightTableName] = src.[RightTableName],
            [Description] = src.[Description],
            [IsActive] = 1,
            [UpdatedAt] = SYSDATETIMEOFFSET()
    WHEN NOT MATCHED THEN
        INSERT
        (
            [ValidationCode],
            [ValidationGroup],
            [LeftSchemaName],
            [LeftTableName],
            [RightSchemaName],
            [RightTableName],
            [Description],
            [IsActive]
        )
        VALUES
        (
            src.[ValidationCode],
            src.[ValidationGroup],
            src.[LeftSchemaName],
            src.[LeftTableName],
            src.[RightSchemaName],
            src.[RightTableName],
            src.[Description],
            1
        );

    ;WITH KeySeed AS
    (
        SELECT tp.[TablePairId], 1 AS [KeyOrdinal], N'CompanyId' AS [KeyName], N'CAST({alias}.[CompanyID] AS NVARCHAR(50))' AS [LeftExpression], N'CAST({alias}.[CompanyId] AS NVARCHAR(50))' AS [RightExpression], N'PARTITION' AS [KeyRole]
        FROM [data_validation].[TablePair] AS tp
        WHERE tp.[ValidationCode] = N'STG.Customer'

        UNION ALL

        SELECT tp.[TablePairId], 2, N'CustomerNo', N'CAST({alias}.[No_] AS NVARCHAR(100))', N'CAST({alias}.[no] AS NVARCHAR(100))', N'BUSINESS'
        FROM [data_validation].[TablePair] AS tp
        WHERE tp.[ValidationCode] = N'STG.Customer'

        UNION ALL

        SELECT tp.[TablePairId], 1, N'CompanyId', N'CAST({alias}.[CompanyID] AS NVARCHAR(50))', N'CAST({alias}.[CompanyId] AS NVARCHAR(50))', N'PARTITION'
        FROM [data_validation].[TablePair] AS tp
        WHERE tp.[ValidationCode] = N'STG.Item'

        UNION ALL

        SELECT tp.[TablePairId], 2, N'ItemNo', N'CAST({alias}.[No_] AS NVARCHAR(100))', N'CAST({alias}.[number] AS NVARCHAR(100))', N'BUSINESS'
        FROM [data_validation].[TablePair] AS tp
        WHERE tp.[ValidationCode] = N'STG.Item'

        UNION ALL

        SELECT tp.[TablePairId], 1, N'CompanyId', N'CAST({alias}.[CustomerCompanyID] AS NVARCHAR(50))', N'CAST({alias}.[CustomerCompanyID] AS NVARCHAR(50))', N'PARTITION'
        FROM [data_validation].[TablePair] AS tp
        WHERE tp.[ValidationCode] = N'DIM.Customer'

        UNION ALL

        SELECT tp.[TablePairId], 2, N'CustomerNo', N'CAST({alias}.[CustomerNo] AS NVARCHAR(100))', N'CAST({alias}.[CustomerNo] AS NVARCHAR(100))', N'BUSINESS'
        FROM [data_validation].[TablePair] AS tp
        WHERE tp.[ValidationCode] = N'DIM.Customer'
    )
    MERGE [data_validation].[TableKey] AS tgt
    USING KeySeed AS src
        ON tgt.[TablePairId] = src.[TablePairId]
       AND tgt.[KeyOrdinal] = src.[KeyOrdinal]
    WHEN MATCHED THEN
        UPDATE SET
            [KeyName] = src.[KeyName],
            [LeftExpression] = src.[LeftExpression],
            [RightExpression] = src.[RightExpression],
            [KeyRole] = src.[KeyRole],
            [IsActive] = 1
    WHEN NOT MATCHED THEN
        INSERT
        (
            [TablePairId],
            [KeyOrdinal],
            [KeyName],
            [LeftExpression],
            [RightExpression],
            [KeyRole],
            [IsActive]
        )
        VALUES
        (
            src.[TablePairId],
            src.[KeyOrdinal],
            src.[KeyName],
            src.[LeftExpression],
            src.[RightExpression],
            src.[KeyRole],
            1
        );

    ;WITH RuleSeed AS
    (
        SELECT tp.[TablePairId], rc.[RuleCode]
        FROM [data_validation].[TablePair] AS tp
        CROSS JOIN
        (
            VALUES
            (N'TABLE_EXISTS'),
            (N'ROWCOUNT_TOTAL'),
            (N'ROWCOUNT_BY_COMPANY'),
            (N'DISTINCT_KEYCOUNT_BY_COMPANY'),
            (N'DUPLICATE_KEYS_LEFT'),
            (N'DUPLICATE_KEYS_RIGHT'),
            (N'MISSING_IN_RIGHT'),
            (N'MISSING_IN_LEFT')
        ) AS rc([RuleCode])
        WHERE tp.[ValidationCode] IN (N'STG.Customer', N'STG.Item', N'DIM.Customer')
    )
    MERGE [data_validation].[Rule] AS tgt
    USING RuleSeed AS src
        ON tgt.[TablePairId] = src.[TablePairId]
       AND tgt.[RuleCode] = src.[RuleCode]
    WHEN MATCHED THEN
        UPDATE SET
            [Severity] = N'ERROR',
            [SampleLimit] = 100,
            [IsActive] = 1
    WHEN NOT MATCHED THEN
        INSERT
        (
            [TablePairId],
            [RuleCode],
            [Severity],
            [SampleLimit],
            [IsActive]
        )
        VALUES
        (
            src.[TablePairId],
            src.[RuleCode],
            N'ERROR',
            100,
            1
        );

    ;WITH CompanyScopeSeed AS
    (
        SELECT tp.[TablePairId], N'1' AS [CompanyId], N'INCLUDE' AS [ScopeType], N'Danmark' AS [Note]
        FROM [data_validation].[TablePair] AS tp
        WHERE tp.[ValidationCode] IN (N'STG.Customer', N'STG.Item', N'DIM.Customer')
    )
    MERGE [data_validation].[CompanyScope] AS tgt
    USING CompanyScopeSeed AS src
        ON tgt.[TablePairId] = src.[TablePairId]
       AND tgt.[CompanyId] = src.[CompanyId]
       AND tgt.[ScopeType] = src.[ScopeType]
    WHEN MATCHED THEN
        UPDATE SET
            [IsActive] = 1,
            [Note] = src.[Note]
    WHEN NOT MATCHED THEN
        INSERT
        (
            [TablePairId],
            [CompanyId],
            [ScopeType],
            [IsActive],
            [Note]
        )
        VALUES
        (
            src.[TablePairId],
            src.[CompanyId],
            src.[ScopeType],
            1,
            src.[Note]
        );
END


GO
