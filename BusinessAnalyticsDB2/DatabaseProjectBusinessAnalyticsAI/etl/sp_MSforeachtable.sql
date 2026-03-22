CREATE PROC [etl].[sp_MSforeachtable]
    @command1 nvarchar(2000)
   ,@replacechar nchar(1) = N'?'
   ,@command2 nvarchar(2000) = NULL
   ,@command3 nvarchar(2000) = NULL
   ,@whereand nvarchar(2000) = NULL
   ,@precommand nvarchar(2000) = NULL
   ,@postcommand nvarchar(2000) = NULL
AS
BEGIN
    /* This proc returns one or more rows for each table (optionally, matching 
@where), with each table defaulting to its own result set */
    /* @precommand and @postcommand may be used to force a single result set via 
a temp table. */

    /* Preprocessor won't replace within quotes so have to use str(). */
    DECLARE @mscat nvarchar(12);
    SELECT @mscat = LTRIM(STR(CONVERT(int, 0x0002)));

    IF(@precommand IS NOT NULL)EXEC(@precommand);

    /* Create the select */
    EXEC(N'declare hCForEachTable cursor global for select ''['' + 
        REPLACE(schema_name(syso.schema_id), N'']'', N'']]'') + '']'' + ''.'' + ''['' + 
        REPLACE(object_name(o.id), N'']'', N'']]'') + '']'' from dbo.sysobjects o join 
        sys.all_objects syso on o.id = syso.object_id ' + N' where OBJECTPROPERTY(o.id, N''IsUserTable'') = 1 ' + N' and o.category & ' + @mscat + N' = 0 ' + @whereand);
    DECLARE @retval int;
    SELECT @retval = @@ERROR;
    IF(@retval = 0)
        EXEC @retval = [etl].[sp_MSforeach_worker] @command1
                                                  ,@replacechar
                                                  ,@command2
                                                  ,@command3
                                                  ,0;

    IF(@retval = 0 AND @postcommand IS NOT NULL)EXEC(@postcommand);

    RETURN @retval;
END;

GO

