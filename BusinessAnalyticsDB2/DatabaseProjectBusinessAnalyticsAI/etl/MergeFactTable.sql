CREATE PROCEDURE [etl].[MergeFactTable]
(
    @TableName nvarchar(255)
   ,@TableTempName nvarchar(255)
   ,@TableTempNamePartOld nvarchar(255) = NULL
   ,@PartitionFunction nvarchar(128) = NULL
   ,@PartitionColumn nvarchar(128) = NULL
   ,@FactTableSource nvarchar(128) = N'' /* Must be specified for UpdateType 4 */
   ,@ColumnDiffExclusions nvarchar(4000) = N'' /* Comma-delimited list of columns from the comparison when deciding whether or not a record has changed (primary key columns are always excluded) */
   ,@ADF_PipelineRunId nvarchar(36)
   ,@RowsInserted bigint = 0 OUTPUT
   ,@RowsUpdated bigint = 0 OUTPUT
   ,@RowsDeleted bigint = 0 OUTPUT
   ,@UpdateType tinyint = 1 /* 1 = INSERT/UPDATE, 11 = DELETE/INSERT (NO UPDATE), 12 = REVERSE updated rows AND INSERT (NO UPDATE), 2 = INSERT, 3 = TRUNCATE/INSERT, 31 = SWITCH PARTION (FULL TABLE), 32 = SWITCH PARTION (INCREMENTAL), 4 = INSERT/UPDATE/DELETE */
   ,@PrintOnly bit = 0 /* 1 = Only outputs @SQLString to client - does not change the database */
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @PipelineRunIdInsertColumn nvarchar(40) = QUOTENAME([etl].[GetConfiguredValue]('PipelineRunIdInsert'))
           ,@PipelineRunIdUpdateColumn nvarchar(40) = QUOTENAME([etl].[GetConfiguredValue]('PipelineRunIdUpdate'))
           ,@ValidFromColumn nvarchar(40) = QUOTENAME([etl].[GetConfiguredValue]('ValidFrom'))
           ,@ValidToColumn nvarchar(40) = QUOTENAME([etl].[GetConfiguredValue]('ValidTo'))
           ,@IsCurrentColumn nvarchar(30) = QUOTENAME([etl].[GetConfiguredValue]('IsCurrent'))
           ,@SQLString nvarchar(MAX)
           ,@SQLString_Truncate nvarchar(MAX)
           ,@SQLString_Merge nvarchar(MAX)
           ,@Columns nvarchar(MAX)
           ,@ReverseColumns nvarchar(MAX)
           ,@SourceColumns nvarchar(MAX)
           ,@KeyColumns nvarchar(MAX)
           ,@ColumnAssignment nvarchar(MAX)
           ,@KeyJoin nvarchar(MAX)
           ,@ColumnDiff nvarchar(MAX)
           ,@ColumnExclusions nvarchar(MAX)
           ,@Now datetimeoffset(2) = SYSDATETIMEOFFSET()
           ,@EOT datetimeoffset(2) = '9999-12-31';
    -- Find columns to exclude (ADF system columns)
    SELECT @ColumnExclusions = STRING_AGG(N'N''' + CAST([c].[ConfigurationValue] AS nvarchar(MAX)) + N'''', N',')
    FROM
    (
        SELECT [ConfigurationValue]
        FROM [etl].[Configuration]
        WHERE [Configuration] IN ( N'PipelineRunIdInsert', 'PipelineRunIdUpdate' )
    ) AS [c];

    -- Get the columns for the destination table
    CREATE TABLE [#Columns]
    (
        [ColumnName] nvarchar(128) NOT NULL
       ,[IsPrimaryKeyColumn] tinyint NOT NULL
       ,[KeyOrdinal] tinyint NULL
       ,[IsDescendingKey] bit NULL
       ,[IsNullable] bit NULL
    );

    SET @SQLString = N'
	SELECT QUOTENAME([c].[name]) AS [ColumnName]
          ,CASE
               WHEN [ic].[column_id] IS NOT NULL THEN
                   CAST(1 AS tinyint)
               ELSE
                   CAST(0 AS tinyint)
           END AS [IsPrimaryKeyColumn]
          ,[ic].[key_ordinal]
          ,[ic].[is_descending_key]
          ,[c].[is_nullable]
    FROM [sys].[objects] AS [o]
    INNER JOIN [sys].[columns] AS [c]
    ON [o].[object_id] = [c].[object_id]
    LEFT JOIN [sys].[indexes] AS [i]
    ON  [o].[object_id] = [i].[object_id]
    AND [i].[is_primary_key] = 1
    LEFT JOIN [sys].[index_columns] AS [ic]
    ON  [c].[column_id] = [ic].[column_id]
    AND [ic].[index_id] = [i].[index_id]
    AND [ic].[object_id] = [i].[object_id]
    LEFT JOIN [sys].[schemas] AS [sc]
    ON [o].[schema_id] = [sc].[schema_id]
	WHERE [o].[object_id] = OBJECT_ID(''<DestinationTable>'')
	AND   [c].[name] NOT IN (<ColumnExclusions>)
	ORDER BY [ic].[key_ordinal];';

    SET @SQLString = REPLACE(@SQLString, N'<DestinationTable>', @TableName);
    SET @SQLString = REPLACE(@SQLString, N'<ColumnExclusions>', @ColumnExclusions);

    INSERT INTO [#Columns]
    (
        [ColumnName]
       ,[IsPrimaryKeyColumn]
       ,[KeyOrdinal]
       ,[IsDescendingKey]
       ,[IsNullable]
    )
    EXECUTE [sys].[sp_executesql] @stmt = @SQLString;

    IF NOT EXISTS (SELECT * FROM [#Columns])
    BEGIN
        ; THROW 51000, 'The specified @TableName does not exist.', 0;
        RETURN (2);
    END;

    -- Test for primary key columns
    IF NOT EXISTS (SELECT * FROM [#Columns] WHERE [IsPrimaryKeyColumn] = 1)
    BEGIN
        ; THROW 51000, 'The specified @TableName does not contain a primary key definition, which is required.', 0;
        RETURN (2);
    END;

    -- For @UpdateType = 31, TableTempNamePartOld must be specified
    IF  @UpdateType = 31
    AND @TableTempNamePartOld IS NULL
    BEGIN
        ; THROW 51000, 'For @UpdateType = 31, TableTempNamePartOld must be specified!', 0;
        RETURN (2);
    END;

    -- For @UpdateType = 32, TableTempNamePartOld, PartitionFunction and PartitionColumns must be specified
    IF @UpdateType = 32
    AND
       (
           @TableTempNamePartOld IS NULL
     OR    @PartitionFunction IS NULL
     OR    @PartitionColumn IS NULL
       )
    BEGIN
        ; THROW 51000, 'For @UpdateType = 32, TableTempNamePartOld, PartitionFunction and PartitionColumns must be specified!', 0;
        RETURN (2);
    END;

    -- For @UpdateType = 4, ADF_FactTableSource must be specified
    IF  @UpdateType = 4
    AND @FactTableSource = ''
    BEGIN
        ; THROW 51000, 'For @UpdateType = 4, ADF_FactTableSource must be specified!', 0;
        RETURN (2);
    END;

    SELECT @Columns = STRING_AGG([c].[ColumnName], CHAR(13) + CHAR(10) + N', ')
          ,@SourceColumns = STRING_AGG(N's.' + [c].[ColumnName], CHAR(13) + CHAR(10) + N', ')
          ,@ReverseColumns = STRING_AGG(   CASE
                                               WHEN SUBSTRING([c].[ColumnName], 1, 3) = N'[M_' THEN
                                                   N'-1 * ' + N'[s].' + [c].[ColumnName] + N' AS ' + [c].[ColumnName]
                                               ELSE
                                                   N'[s].' + [c].[ColumnName]
                                           END
                                          ,CHAR(13) + CHAR(10) + N', '
                                       )
    FROM [#Columns] AS [c]
    WHERE [c].[ColumnName] <> @PipelineRunIdInsertColumn;

    SELECT @KeyJoin = STRING_AGG('s.' + [c].[ColumnName] + ' = d.' + [c].[ColumnName], ' AND ')
          ,@KeyColumns = STRING_AGG(   [c].[ColumnName] + CASE
                                                              WHEN [c].[IsDescendingKey] = 1 THEN
                                                                  ' DESC'
                                                              ELSE
                                                                  ' ASC'
                                                          END
                                      ,', '
                                   )
    FROM [#Columns] AS [c]
    WHERE [c].[IsPrimaryKeyColumn] = 1
    AND   [c].[ColumnName] <> @PipelineRunIdInsertColumn;

    SELECT @ColumnAssignment = STRING_AGG('d.' + [c].[ColumnName] + ' = s.' + [c].[ColumnName], CHAR(13) + CHAR(10) + N', ')
          ,@ColumnDiff = STRING_AGG(
                                       CASE
                                           WHEN [c].[IsNullable] = 1 THEN
                                               CAST('(d.' + [c].[ColumnName] + ' <> s.' + [c].[ColumnName] + ' OR (d.' + [c].[ColumnName] + ' IS NULL AND s.' + [c].[ColumnName] + ' IS NOT NULL) OR (d.' + [c].[ColumnName]
                                                    + ' IS NOT NULL AND s.' + [c].[ColumnName] + ' IS NULL))' AS nvarchar(MAX))
                                           ELSE
                                               CAST('(d.' + [c].[ColumnName] + ' <> s.' + [c].[ColumnName] + ')' AS nvarchar(MAX))
                                       END
                                      ,CHAR(13) + CHAR(10) + N' OR '
                                   )
    FROM [#Columns] AS [c]
    WHERE [c].[IsPrimaryKeyColumn] = 0
    AND   [c].[ColumnName] <> @PipelineRunIdInsertColumn
    AND   [c].[ColumnName] NOT IN
          (
              SELECT QUOTENAME([Value])
			  FROM STRING_SPLIT(@ColumnDiffExclusions, N',')
          );

    /* CREATE PARTITION SWITCHING STRING */
    DECLARE @PartSql nvarchar(MAX) = N'';
    DECLARE @IndexName nvarchar(128) = N'';

    IF @UpdateType IN ( 31, 32 )
    BEGIN

        DECLARE @partitions table
        (
            [partition_number] int NOT NULL
           ,[index_name] nvarchar(130) NOT NULL
        );
        DECLARE @SqlPartitionNumbers nvarchar(MAX) = N'
        SELECT  [p].[partition_number]
               ,QUOTENAME([i].[name]) AS [index_name]
        FROM    [sys].[partitions] AS [p] WITH(NOLOCK)
        INNER JOIN [sys].[indexes] AS [i] WITH(NOLOCK)
        ON  [i].[object_id] = [p].[object_id]
        AND [i].[index_id] = [p].[index_id]
        WHERE   [p].[object_id] = OBJECT_ID(N''<TableTempName>'', N''U'')
          AND   [p].[index_id] = 1
          AND   [p].[rows] > 0;
        ';
        
		SET @SqlPartitionNumbers = REPLACE(@SqlPartitionNumbers, N'<TableTempName>', @TableTempName);

        INSERT INTO @partitions
        EXECUTE [sys].[sp_executesql] @stm = @SqlPartitionNumbers;

        SET @IndexName =
        (
            SELECT TOP(1)[index_name] 
			FROM @partitions
        );

        IF @UpdateType = 31
        BEGIN

            SELECT @PartSql = @PartSql + N'ALTER TABLE ' + @TableName + N' SWITCH PARTITION ' + CAST([partition_number] AS nvarchar(10)) + N' TO ' + @TableTempNamePartOld + N' PARTITION ' + CAST([partition_number] AS nvarchar(10))
                              + NCHAR(13) + NCHAR(10) + N'ALTER TABLE ' + @TableTempName + N' SWITCH PARTITION ' + CAST([partition_number] AS nvarchar(10)) + N' TO ' + @TableName + N' PARTITION ' + CAST([partition_number] AS nvarchar(10))
                              + NCHAR(13) + NCHAR(10)
            FROM @partitions;
        END;
        ELSE IF @UpdateType = 32
        BEGIN

           SELECT @PartSql = @PartSql + N'INSERT INTO ' + @TableTempName + NCHAR(13) + NCHAR(10) + N'SELECT * FROM ' + @TableName + N' AS s WHERE $PARTITION.' + @PartitionFunction + N'(s.' + @PartitionColumn + N') = '
                              + CAST([p].[partition_number] AS nvarchar(10)) + N' AND NOT EXISTS (SELECT 1 FROM ' + @TableTempName + N' AS d WHERE ' + @KeyJoin + N')' + NCHAR(13) + NCHAR(10) + N'ALTER INDEX ' + @IndexName + N' ON '
                              + @TableTempName + N'  REBUILD PARTITION = ' + CAST([p].[partition_number] AS nvarchar(10)) + N' WITH (MAXDOP = 1, DATA_COMPRESSION = COLUMNSTORE)' + NCHAR(13) + NCHAR(10) + N'ALTER TABLE ' + @TableName
                              + N' SWITCH PARTITION ' + CAST([p].[partition_number] AS nvarchar(10)) + N' TO ' + @TableTempNamePartOld + N' PARTITION ' + CAST([p].[partition_number] AS nvarchar(10)) + NCHAR(13) + NCHAR(10)
                              + N'WITH (WAIT_AT_LOW_PRIORITY (MAX_DURATION = 1 MINUTES, ABORT_AFTER_WAIT = BLOCKERS));' + NCHAR(13) + NCHAR(10) + N'ALTER TABLE ' + @TableTempName + N' SWITCH PARTITION '
                              + CAST([p].[partition_number] AS nvarchar(10)) + N' TO ' + @TableName + N' PARTITION ' + CAST([p].[partition_number] AS nvarchar(10)) + NCHAR(13) + NCHAR(10)
                              + N'WITH (WAIT_AT_LOW_PRIORITY (MAX_DURATION = 0 MINUTES, ABORT_AFTER_WAIT = BLOCKERS));' + NCHAR(13) + NCHAR(10)
            FROM @partitions AS [p];
        END;
    END;

    SET @SQLString = N'
	CREATE UNIQUE CLUSTERED INDEX IX_PK ON <SourceTable>
	(
		<KeyColumns>
	);';

    SET @SQLString = REPLACE(@SQLString, N'<KeyColumns>', @KeyColumns);
    SET @SQLString = REPLACE(@SQLString, N'<SourceTable>', @TableTempName);

    -- Create clustered index on the temp table to match the PK on the destination table
    IF @PrintOnly = 1
    BEGIN
        SELECT @SQLString AS [SQLString]
        FOR XML PATH('');
    END;
    ELSE
    BEGIN
        IF @UpdateType NOT IN ( 31, 32 )
        BEGIN
            EXECUTE [sys].[sp_executesql] @stmt = @SQLString;
        END;
    END;

    SET @SQLString = N'
	CREATE TABLE #RowsAffected
	(
		[Action] CHAR(6) NOT NULL
	);

	<TruncateString>

	<MergeString>

	SELECT @RowsInserted = [INSERT]
	      ,@RowsUpdated = [UPDATE]
	      ,@RowsDeleted = [DELETE]
	FROM 
	(
		SELECT [Action]
		FROM #RowsAffected [ra]
	) [tbl]
	PIVOT 
	(
		COUNT([Action])
		FOR [Action] IN ([INSERT], [UPDATE], [DELETE])
	) [pvt];';

    -- Depending on the @UpdateType, vary the MERGE statement
    IF @UpdateType = 1
    BEGIN
        -- Data is inserted and updated
        SET @SQLString_Merge = N'
	MERGE <DestinationTable> [d]
	USING
	(
	SELECT <Columns>
	FROM <SourceTable> [s] WITH (TABLOCK)
	) [s] ON <KeyJoin>
	WHEN NOT MATCHED BY TARGET THEN
	INSERT (<Columns>
	, <PipelineRunIdInsert>
	, <PipelineRunIdUpdate>)
	VALUES (<Columns>
	, <ADF_PipelineRunId>
	, <ADF_PipelineRunId>)
	WHEN MATCHED AND 
	(
	<ColumnDiff>
	)
	THEN
	UPDATE
	SET <ColumnAssignment>
	, [d].<PipelineRunIdUpdate> = <ADF_PipelineRunId>
	OUTPUT $action AS [Action] INTO #RowsAffected
	OPTION (RECOMPILE);';
        SET @SQLString_Truncate = N'';
    END;

    /* DELETE/INSERT instead of MERGE */
    ELSE IF @UpdateType = 11
    BEGIN
        -- Data is deleted and inserted

        -- Data is deleted and inserted
        SET @SQLString = N'
	<MergeString>';

        SET @SQLString_Merge = N'
		DELETE [d]
		FROM <DestinationTable> [d]
		INNER JOIN <SourceTable> [s] WITH (TABLOCK)
		ON <KeyJoin>
		OPTION (RECOMPILE);
		SET @RowsDeleted = @@ROWCOUNT;

		INSERT INTO <DestinationTable>
		( <Columns>
		, [ADF_PipelineRunId_Insert]
		, [ADF_PipelineRunId_Update])

		SELECT <Columns>
			  ,<ADF_PipelineRunId> AS [ADF_PipelineRunId_Insert]
			  ,<ADF_PipelineRunId> AS [ADF_PipelineRunId_Update]
		FROM <SourceTable> WITH (TABLOCK)
		OPTION (RECOMPILE);
		SET @RowsInserted = @@ROWCOUNT;';

        SET @SQLString_Truncate = N'';

    END;

    /* REVERSE Updated rows AND INSERT instead of MERGE */
    ELSE IF @UpdateType = 12
    BEGIN
        -- Data is deleted and inserted

        -- Data is deleted and inserted
        SET @SQLString = N'
	<MergeString>';

        SET @SQLString_Merge = N'
		INSERT INTO <SourceTable>
		( <Columns>
         ,[ADF_PipelineRunId_Insert]
         ,[ADF_PipelineRunId_Update]
         ,[ADF_OriginalRow]
		)
		SELECT <ReverseColumns>
              ,[ADF_PipelineRunId_Insert]
              ,<ADF_PipelineRunId> AS [ADF_PipelineRunId_Update]
              ,CAST(0 AS bit) AS [ADF_OriginalRow]
		FROM <DestinationTable> [d]
		INNER JOIN <SourceTable> [s] WITH (TABLOCK)
		ON <KeyJoin>
		OPTION (RECOMPILE);
		SET @RowsDeleted = @@ROWCOUNT;

		INSERT INTO <DestinationTable>
		( <Columns>
		, [ADF_PipelineRunId_Insert]
		, [ADF_PipelineRunId_Update])

		SELECT <Columns>
			  ,<ADF_PipelineRunId> AS [ADF_PipelineRunId_Insert]
			  ,<ADF_PipelineRunId> AS [ADF_PipelineRunId_Update]
		FROM <SourceTable> WITH (TABLOCK)
		OPTION (RECOMPILE);
		SET @RowsInserted = @@ROWCOUNT;';

        SET @SQLString_Truncate = N'';

    END;

    ELSE IF @UpdateType = 2
    BEGIN
        -- Data is only inserted
        SET @SQLString_Truncate = N'';
        SET @SQLString_Merge = N'
	MERGE <DestinationTable> [d]
	USING
	(
	SELECT <Columns>
	FROM <SourceTable> [s] WITH (TABLOCK)
	) [s] ON <KeyJoin>
	WHEN NOT MATCHED BY TARGET THEN
	INSERT ( <Columns>
	        ,<PipelineRunIdInsert>
	        ,<PipelineRunIdUpdate>)
	VALUES ( <Columns>
	        ,<ADF_PipelineRunId>
	        ,<ADF_PipelineRunId>)
	OUTPUT $action AS [Action] INTO #RowsAffected
	OPTION (RECOMPILE);';

    END;
    ELSE IF @UpdateType = 3
    BEGIN
        -- Destination is truncated and data is inserted
        SET @SQLString_Truncate = N'TRUNCATE TABLE <DestinationTable>;';
        SET @SQLString_Merge = N'
	INSERT INTO <DestinationTable>
	(
	  <Columns>
	 ,<PipelineRunIdInsert>
	 ,<PipelineRunIdUpdate>
	)
	SELECT <Columns>
	      ,<ADF_PipelineRunId>
	      ,<ADF_PipelineRunId>
	FROM <SourceTable> AS [s] WITH (TABLOCK)
	OPTION (RECOMPILE);

	SELECT @RowsInserted = @@ROWCOUNT;
	';

    END;

    /* Use partition switching during full load */
    ELSE IF @UpdateType = 31
    BEGIN
        -- Destination is replaced using partition switching
        SET @SQLString_Truncate = N'';
        SET @SQLString = N'
	TRUNCATE TABLE <TableTempNamePartOld>

	<MergeString>';
        SET @SQLString_Merge = N'<PartSql>

	SELECT @RowsInserted = COUNT(*) FROM <DestinationTable> WHERE [ADF_PipelineRunId_Update] = <ADF_PipelineRunId>;';

    END;
    /* Use partition switching during delta load*/
    ELSE IF @UpdateType = 32
    BEGIN
        -- Destination is replaced using partition switching
        SET @SQLString_Truncate = N'';
        SET @SQLString = N'
	TRUNCATE TABLE <TableTempNamePartOld>

	<MergeString>';
        SET @SQLString_Merge = N'<PartSql>

	SELECT @RowsInserted = COUNT(*) FROM <DestinationTable> WHERE [ADF_PipelineRunId_Update] = <ADF_PipelineRunId>;';

    END;
    ELSE IF @UpdateType = 4
    BEGIN
        -- Delete data from destination if not exists in source and ADF_FactSource equals specified value
        SET @SQLString_Truncate = N'';
        SET @SQLString = N'
		<MergeString>';
        SET @SQLString_Merge = N'
		UPDATE [d]
		SET <ColumnAssignment>
		  , [d].<PipelineRunIdUpdate> = <ADF_PipelineRunId>
		FROM <DestinationTable> [d]
		INNER JOIN <SourceTable> [s] WITH (TABLOCK)
		ON <KeyJoin>
		WHERE
		(
			<ColumnDiff>
		)
		OPTION (RECOMPILE);
		SET @RowsUpdated = @@ROWCOUNT;

		DELETE [d]
		FROM <DestinationTable> [d]
		WHERE NOT EXISTS 
		(
			SELECT 1
			FROM <SourceTable> AS [s] WITH (TABLOCK)
			WHERE <KeyJoin>
		)
		AND ([d].ADF_FactSource = ''<FactTableSource>'' OR ''All'' = ''<FactTableSource>'')
		OPTION (RECOMPILE);
		SET @RowsDeleted = @@ROWCOUNT;

		INSERT INTO <DestinationTable>
		(  <Columns>
		  ,[ADF_PipelineRunId_Insert]
		  ,[ADF_PipelineRunId_Update]
		)

		SELECT <Columns>
			  ,<ADF_PipelineRunId> AS [ADF_PipelineRunId_Insert]
			  ,<ADF_PipelineRunId> AS [ADF_PipelineRunId_Update]
		FROM <SourceTable> AS [s] WITH (TABLOCK)
		WHERE NOT EXISTS
		(
			SELECT 1
			FROM <DestinationTable> [d]
			WHERE <KeyJoin>
		)
		OPTION (RECOMPILE);
		SET @RowsInserted = @@ROWCOUNT;
		
		SELECT @RowsInserted
			 , @RowsUpdated
			 , @RowsDeleted';

    END;
    ELSE
    BEGIN
        RAISERROR(N'The specified @UpdateType is not supported.', 16, 1);
        RETURN (2);
    END;

    SET @SQLString = REPLACE(@SQLString, N'<MergeString>', @SQLString_Merge);
    SET @SQLString = REPLACE(@SQLString, N'<TruncateString>', @SQLString_Truncate);
    SET @SQLString = REPLACE(@SQLString, N'<DestinationTable>', @TableName);
    SET @SQLString = REPLACE(@SQLString, N'<SourceTable>', @TableTempName);
    SET @SQLString = REPLACE(@SQLString, N'<TableTempNamePartOld>', ISNULL(@TableTempNamePartOld, N''));
    SET @SQLString = REPLACE(@SQLString, N'<PartSql>', @PartSql);
    SET @SQLString = REPLACE(@SQLString, N'<FactTableSource>', @FactTableSource);
    SET @SQLString = REPLACE(@SQLString, N'<KeyJoin>', @KeyJoin);
    SET @SQLString = REPLACE(@SQLString, N'<Columns>', @Columns);
    SET @SQLString = REPLACE(@SQLString, N'<ReverseColumns>', @ReverseColumns);
    SET @SQLString = REPLACE(@SQLString, N'<SourceColumns>', @SourceColumns);
    SET @SQLString = REPLACE(@SQLString, N'<ColumnDiff>', @ColumnDiff);
    SET @SQLString = REPLACE(@SQLString, N'<ColumnAssignment>', @ColumnAssignment);
    SET @SQLString = REPLACE(@SQLString, N'<ValidFrom>', @ValidFromColumn);
    SET @SQLString = REPLACE(@SQLString, N'<ValidTo>', @ValidToColumn);
    SET @SQLString = REPLACE(@SQLString, N'<Now>', @Now);
    SET @SQLString = REPLACE(@SQLString, N'<EOT>', @EOT);
    SET @SQLString = REPLACE(@SQLString, N'<PipelineRunIdInsert>', @PipelineRunIdInsertColumn);
    SET @SQLString = REPLACE(@SQLString, N'<PipelineRunIdUpdate>', @PipelineRunIdUpdateColumn);
    SET @SQLString = REPLACE(@SQLString, N'<IsCurrentColumn>', @IsCurrentColumn);
    SET @SQLString = REPLACE(@SQLString, N'<ADF_PipelineRunId>', CAST(@ADF_PipelineRunId AS nvarchar(20)));

    BEGIN TRY

        -- Get the current transaction count
        DECLARE @TranCounter int = @@TRANCOUNT
               ,@SavePoint nvarchar(32) = CAST(@@PROCID AS nvarchar(20)) + N'_' + CAST(@@NESTLEVEL AS nvarchar(2));

        -- Decide to join existing transaction or start new
        IF @TranCounter > 0 SAVE TRANSACTION @SavePoint;
        ELSE BEGIN TRANSACTION;

        IF @PrintOnly = 1
        BEGIN
            SELECT @SQLString AS [SQLString]
            FOR XML PATH('');
        END;
        ELSE
        BEGIN
            DECLARE @parmdefinition nvarchar(MAX) = N'@RowsInserted BIGINT OUTPUT
													, @RowsUpdated BIGINT OUTPUT
													, @RowsDeleted BIGINT OUTPUT';

            EXECUTE [sys].[sp_executesql] @stmt = @SQLString
                                         ,@params = @parmdefinition
                                         ,@RowsInserted = @RowsInserted OUTPUT
                                         ,@RowsUpdated = @RowsUpdated OUTPUT
                                         ,@RowsDeleted = @RowsDeleted OUTPUT;
        END;

        SELECT @RowsInserted = ISNULL(@RowsInserted, 0)
              ,@RowsUpdated = ISNULL(@RowsUpdated, 0)
              ,@RowsDeleted = ISNULL(@RowsDeleted, 0);

        -- Commit only if the transaction was started in this procedure
        IF @TranCounter = 0 COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH

        -- Rollback if transaction was started in this procedure
        IF @TranCounter = 0 ROLLBACK TRANSACTION;
        -- Nested transaction OK
        ELSE IF XACT_STATE() = 1 ROLLBACK TRANSACTION @SavePoint;
        -- Rollback!
        ELSE IF XACT_STATE() = -1 ROLLBACK TRANSACTION;

        THROW;
        RETURN (1);

    END CATCH;
END;

GO

