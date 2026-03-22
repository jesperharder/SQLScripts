CREATE   PROCEDURE [meta].[GenerateTableSchemaForNavDbTables]
(
    @DatabaseName nvarchar(MAX)
   ,@SourceTable nvarchar(MAX)
   ,@SourceTableSchema nvarchar(MAX)
   ,@DestinationTable nvarchar(MAX)
   ,@DestinationTableSchema nvarchar(MAX)
   ,@NAVTemplateCompany nvarchar(MAX)
)
AS
BEGIN
    DECLARE @SQLString nvarchar(MAX)
           ,@ColumnDefinition nvarchar(MAX)
           ,@PrimaryKeyDefinition nvarchar(MAX)
           ,@DefaultConstraintTableName nvarchar(MAX);

    SET @DefaultConstraintTableName = REPLACE(REPLACE(@DestinationTable, '[', ''), ']', '');
    SET @SourceTable = CONCAT(@NAVTemplateCompany, N'$', @SourceTable);

    DECLARE @Columns table
    (
        [name] sysname NULL
       ,[is_nullable] bit NULL
       ,[system_type_name] sysname NULL
       ,[ColumnOrderKey] int NULL
    );

    DECLARE @PrimaryKeyColumns table
    (
        [ColumnName] sysname NULL
       ,[IsPrimaryKeyColumn] bit NULL
       ,[key_ordinal] tinyint NULL
       ,[is_nullable] bit NULL
    );

    INSERT INTO @Columns
    (
        [name]
       ,[is_nullable]
       ,[system_type_name]
       ,[ColumnOrderKey]
    )
    SELECT [tc].[COLUMN_NAME] AS [name]
          ,IIF([tc].[IS_NULLABLE] = N'NO', 0, 1) AS [is_nullable]
          ,CASE [tc].[DATA_TYPE]
               WHEN 'timestamp' THEN
                   'varbinary(8)'
               WHEN 'image' THEN
                   'varbinary(MAX)'
               WHEN 'sql_variant' THEN
                   'nvarchar(100)'
               WHEN 'uniqueidentifier' THEN
                   'nvarchar(36)'
               WHEN 'ntext' THEN
                   'nvarchar(MAX)'
               WHEN 'text' THEN
                   'nvarchar(MAX)'
               WHEN 'decimal' THEN
                   [tc].[DATA_TYPE] + CONCAT('(', [tc].[NUMERIC_PRECISION], ', ', [tc].[NUMERIC_SCALE], ')')
               WHEN 'numeric' THEN
                   [tc].[DATA_TYPE] + CONCAT('(', [tc].[NUMERIC_PRECISION], ', ', [tc].[NUMERIC_SCALE], ')')
               WHEN 'money' THEN
                   [tc].[DATA_TYPE] + CONCAT('(', [tc].[NUMERIC_PRECISION], ', ', [tc].[NUMERIC_SCALE], ')')
               ELSE
                   CASE
                       WHEN [tc].[CHARACTER_MAXIMUM_LENGTH] IS NULL THEN
                           [tc].[DATA_TYPE]
                       ELSE
                           IIF([tc].[DATA_TYPE] = N'varchar', N'nvarchar', [tc].[DATA_TYPE]) + '(' + CAST([tc].[CHARACTER_MAXIMUM_LENGTH] AS nvarchar(28)) + ')'
                   END
           END AS [system_type_name]
          ,[tc].[ORDINAL_POSITION] AS [ColumnOrderKey]
    FROM [meta].[TableColumns] AS [tc]
    WHERE [tc].[TABLE_CATALOG] = @DatabaseName
    AND   [tc].[TABLE_SCHEMA] = @SourceTableSchema
    AND   [tc].[TABLE_NAME] = @SourceTable
    ORDER BY [tc].[ORDINAL_POSITION];

    INSERT INTO @PrimaryKeyColumns
    (
        [ColumnName]
       ,[IsPrimaryKeyColumn]
       ,[key_ordinal]
       ,[is_nullable]
    )
    SELECT QUOTENAME([tc].[COLUMN_NAME]) AS [ColumnName]
          ,CASE
               WHEN [pk].[KeyOrderNr] IS NOT NULL THEN
                   CAST(1 AS tinyint)
               ELSE
                   CAST(0 AS tinyint)
           END AS [IsPrimaryKeyColumn]
          ,[pk].[KeyOrderNr]
          ,IIF([tc].[IS_NULLABLE] = N'NO', 0, 1) AS [is_nullable]
    FROM [meta].[TableColumns] AS [tc]
    LEFT JOIN [meta].[PrimaryKeys] AS [pk]
    ON  [pk].[TableCatalog] = [tc].[TABLE_CATALOG]
    AND [pk].[SchemaName] = [tc].[TABLE_SCHEMA]
    AND [pk].[TableName] = [tc].[TABLE_NAME]
    AND [pk].[ColumnName] = [tc].[COLUMN_NAME]
    WHERE [tc].[TABLE_SCHEMA] = @SourceTableSchema
    AND   [tc].[TABLE_NAME] = @SourceTable
    AND   [pk].[KeyOrderNr] IS NOT NULL
    ORDER BY [pk].[KeyOrderNr];

    IF NOT EXISTS (SELECT COUNT(*)FROM @Columns)
    BEGIN
        SELECT 'The specified table does not exist in the specified database or all columns have been excluded.' AS [ErrorMessage];
    END;

    SELECT @ColumnDefinition = STRING_AGG(
                                             QUOTENAME(CAST([c].[name] AS nvarchar(MAX))) + N' '
                                             + REPLACE(
                                                          REPLACE(REPLACE(REPLACE(CAST([c].[system_type_name] AS nvarchar(MAX)), N'image', N'varbinary(MAX)'), N'timestamp', N'varbinary(8)'), N'sql_variant', N'nvarchar(100)')
                                                         ,N'uniqueidentifier'
                                                         ,N'nvarchar(36)'
                                                      ) + CASE
                                                              WHEN [c].[is_nullable] = 1 THEN
                                                                  N' NULL'
                                                              ELSE
                                                                  N' NOT NULL'
                                                          END
                                            ,N', '
                                         )
    FROM
    (SELECT TOP(100000000)* FROM @Columns ORDER BY [ColumnOrderKey]) AS [c];

    PRINT @ColumnDefinition;

    SELECT @PrimaryKeyDefinition = STRING_AGG(CAST([pkc].[ColumnName] AS nvarchar(MAX)) + N' ASC', N', ')
    FROM
    (SELECT TOP(100000000)* FROM @PrimaryKeyColumns ORDER BY [key_ordinal]) AS [pkc];

    PRINT @PrimaryKeyDefinition;

    SET @SQLString = N'CREATE TABLE [<DestinationTableSchema>].[<DestinationTable>] ( <ColumnDefinition>, [PipelineName] nvarchar(200) NOT NULL CONSTRAINT [DF_<DefaultConstraintTableName>_PipelineName] DEFAULT(''Default''), [PipelineRunId] nvarchar(36) NOT NULL CONSTRAINT [DF_<DefaultConstraintTableName>_PipelineRunId] DEFAULT(''00000000-0000-0000-0000-000000000000''), [PipelineTriggerTime] datetimeoffset(0) NOT NULL CONSTRAINT [DF_<DefaultConstraintTableName>_PipelineTriggerTime] DEFAULT(SYSDATETIMEOFFSET()), [CompanyID] int NOT NULL, CONSTRAINT [PK_<DestinationTableSchema>_<DefaultConstraintTableName>] PRIMARY KEY CLUSTERED ( [CompanyID] ASC, <PrimaryKeyDefinition> ) WITH (DATA_COMPRESSION = ROW) )';

    SET @SQLString = REPLACE(@SQLString, N'<DestinationTable>', @DestinationTable);
    SET @SQLString = REPLACE(@SQLString, N'<DestinationTableSchema>', @DestinationTableSchema);
    SET @SQLString = REPLACE(@SQLString, N'<ColumnDefinition>', @ColumnDefinition);
    SET @SQLString = REPLACE(@SQLString, N'<PrimaryKeyDefinition>', @PrimaryKeyDefinition);
    SET @SQLString = REPLACE(@SQLString, N'<DefaultConstraintTableName>', @DefaultConstraintTableName);

    SELECT @SQLString AS [CreateTableScript];
END;

GO

