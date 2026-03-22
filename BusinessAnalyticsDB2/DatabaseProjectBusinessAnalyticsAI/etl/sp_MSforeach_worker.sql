CREATE PROC [etl].[sp_MSforeach_worker]
    @command1 nvarchar(2000)
   ,@replacechar nchar(1) = N'?'
   ,@command2 nvarchar(2000) = NULL
   ,@command3 nvarchar(2000) = NULL
   ,@worker_type int = 1
AS
BEGIN
    CREATE TABLE [#qtemp]
    (/* Temp command storage */
        [qnum] int NOT NULL
       ,[qchar] nvarchar(2000) COLLATE DATABASE_DEFAULT NULL
    );

    SET NOCOUNT ON;
    DECLARE @name nvarchar(517)
           ,@namelen int
           ,@q1 nvarchar(2000)
           ,@q2 nvarchar(2000);
    DECLARE @q3 nvarchar(2000)
           ,@q4 nvarchar(2000)
           ,@q5 nvarchar(2000);
    DECLARE @q6 nvarchar(2000)
           ,@q7 nvarchar(2000)
           ,@q8 nvarchar(2000)
           ,@q9 nvarchar(2000)
           ,@q10 nvarchar(2000);
    DECLARE @cmd nvarchar(2000)
           ,@replacecharindex int
           ,@useq tinyint
           ,@usecmd tinyint
           ,@nextcmd nvarchar(2000);
    DECLARE @namesave nvarchar(517)
           ,@nametmp nvarchar(517)
           ,@nametmp2 nvarchar(258);

    DECLARE @local_cursor CURSOR;
    IF @worker_type = 1 SET @local_cursor = [hCForEachDatabase];
    ELSE SET @local_cursor = [hCForEachTable];

    OPEN @local_cursor;
    FETCH @local_cursor
    INTO @name;

    WHILE(@@FETCH_STATUS >= 0)
    BEGIN

        SELECT @namesave = @name;
        SELECT @useq = 1
              ,@usecmd = 1
              ,@cmd = @command1
              ,@namelen = DATALENGTH(@name);
        WHILE(@cmd IS NOT NULL)
        BEGIN /* Generate @q* for exec() */
            SELECT @replacecharindex = CHARINDEX(@replacechar, @cmd);
            WHILE(@replacecharindex <> 0)
            BEGIN

                /* 7.0, if name contains ' character, and the name has been single quoted in command, double all of them in dbname */
                /* if the name has not been single quoted in command, do not doulbe them */
                /* if name contains ] character, and the name has been [] quoted in command, double all of ] in dbname */
                SELECT @name = @namesave;
                SELECT @namelen = DATALENGTH(@name);
                DECLARE @tempindex int;
                IF(SUBSTRING(@cmd, @replacecharindex - 1, 1) = N'''')
                BEGIN
                    /* if ? is inside of '', we need to double all the ' in name */
                    SELECT @name = REPLACE(@name, N'''', N'''''');
                END;
                ELSE IF(SUBSTRING(@cmd, @replacecharindex - 1, 1) = N'[')
                BEGIN
                    /* if ? is inside of [], we need to double all the ] in name */
                    SELECT @name = REPLACE(@name, N']', N']]');
                END;
                ELSE IF((@name LIKE N'%].%]') AND (SUBSTRING(@name, 1, 1) = N'['))
                BEGIN
                    /* ? is NOT inside of [] nor '', and the name is in [owner].[name] format, handle it */
                    /* !!! work around, when using LIKE to find string pattern, can't use '[', since LIKE operator is treating '[' as a wide char */
                    SELECT @tempindex = CHARINDEX(N'].[', @name);
                    SELECT @nametmp = SUBSTRING(@name, 2, @tempindex - 2);
                    SELECT @nametmp2 = SUBSTRING(@name, @tempindex + 3, LEN(@name) - @tempindex - 3);
                    SELECT @nametmp = REPLACE(@nametmp, N']', N']]');
                    SELECT @nametmp2 = REPLACE(@nametmp2, N']', N']]');
                    SELECT @name = N'[' + @nametmp + N'].[' + @nametmp2 + N']';
                END;
                ELSE IF((@name LIKE N'%]') AND (SUBSTRING(@name, 1, 1) = N'['))
                BEGIN
                    /* ? is NOT inside of [] nor '', and the name is in [name] format, handle it */
                    /* j.i.c., since we should not fall into this case */
                    /* !!! work around, when using LIKE to find string pattern, can't use '[', since LIKE operator is treating '[' as a wide char */
                    SELECT @nametmp = SUBSTRING(@name, 2, LEN(@name) - 2);
                    SELECT @nametmp = REPLACE(@nametmp, N']', N']]');
                    SELECT @name = N'[' + @nametmp + N']';
                END;
                /* Get the new length */
                SELECT @namelen = DATALENGTH(@name);

                /* start normal process */
                IF(DATALENGTH(@cmd) + @namelen - 1 > 2000)
                BEGIN
                    /* Overflow; put preceding stuff into the temp table */
                    IF(@useq > 9)
                    BEGIN
                        CLOSE @local_cursor;
                        IF @worker_type = 1 DEALLOCATE [hCForEachDatabase];
                        ELSE DEALLOCATE [hCForEachTable];
                        RETURN 1;
                    END;
                    IF(@replacecharindex < @namelen)
                    BEGIN
                        /* If this happened close to beginning, make sure expansion has enough room. */
                        /* In this case no trailing space can occur as the row ends with @name. */
                        SELECT @nextcmd = SUBSTRING(@cmd, 1, @replacecharindex);
                        SELECT @cmd = SUBSTRING(@cmd, @replacecharindex + 1, 2000);
                        SELECT @nextcmd = STUFF(@nextcmd, @replacecharindex, 1, @name);
                        SELECT @replacecharindex = CHARINDEX(@replacechar, @cmd);
                        INSERT [#qtemp]
                        VALUES
                        (
                            @useq, @nextcmd
                        );
                        SELECT @useq = @useq + 1;
                        CONTINUE;
                    END;
                    /* Move the string down and stuff() in-place. */
                    /* Because varchar columns trim trailing spaces, we may need to prepend one to the following string. */
                    /* In this case, the char to be replaced is moved over by one. */
                    INSERT [#qtemp]
                    VALUES
                    (
                        @useq, SUBSTRING(@cmd, 1, @replacecharindex - 1)
                    );
                    IF(SUBSTRING(@cmd, @replacecharindex - 1, 1) = N' ')
                    BEGIN
                        SELECT @cmd = N' ' + SUBSTRING(@cmd, @replacecharindex, 2000);
                        SELECT @replacecharindex = 2;
                    END;
                    ELSE
                    BEGIN
                        SELECT @cmd = SUBSTRING(@cmd, @replacecharindex, 2000);
                        SELECT @replacecharindex = 1;
                    END;
                    SELECT @useq = @useq + 1;
                END;
                SELECT @cmd = STUFF(@cmd, @replacecharindex, 1, @name);
                SELECT @replacecharindex = CHARINDEX(@replacechar, @cmd);
            END;

            /* Done replacing for current @cmd.  Get the next one and see if it's to be appended. */
            SELECT @usecmd = @usecmd + 1;
            SELECT @nextcmd = CASE (@usecmd)
                                  WHEN 2 THEN
                                      @command2
                                  WHEN 3 THEN
                                      @command3
                                  ELSE
                                      NULL
                              END;
            IF(@nextcmd IS NOT NULL AND SUBSTRING(@nextcmd, 1, 2) = N'++')
            BEGIN
                INSERT [#qtemp]
                VALUES
                (
                    @useq, @cmd
                );
                SELECT @cmd = SUBSTRING(@nextcmd, 3, 2000)
                      ,@useq = @useq + 1;
                CONTINUE;
            END;

            /* Now exec() the generated @q*, and see if we had more commands to exec().  Continue even if errors. */
            /* Null them first as the no-result-set case won't. */
            SELECT @q1 = NULL
                  ,@q2 = NULL
                  ,@q3 = NULL
                  ,@q4 = NULL
                  ,@q5 = NULL
                  ,@q6 = NULL
                  ,@q7 = NULL
                  ,@q8 = NULL
                  ,@q9 = NULL
                  ,@q10 = NULL;
            SELECT @q1 = [qchar]
            FROM [#qtemp]
            WHERE [qnum] = 1;
            SELECT @q2 = [qchar]
            FROM [#qtemp]
            WHERE [qnum] = 2;
            SELECT @q3 = [qchar]
            FROM [#qtemp]
            WHERE [qnum] = 3;
            SELECT @q4 = [qchar]
            FROM [#qtemp]
            WHERE [qnum] = 4;
            SELECT @q5 = [qchar]
            FROM [#qtemp]
            WHERE [qnum] = 5;
            SELECT @q6 = [qchar]
            FROM [#qtemp]
            WHERE [qnum] = 6;
            SELECT @q7 = [qchar]
            FROM [#qtemp]
            WHERE [qnum] = 7;
            SELECT @q8 = [qchar]
            FROM [#qtemp]
            WHERE [qnum] = 8;
            SELECT @q9 = [qchar]
            FROM [#qtemp]
            WHERE [qnum] = 9;
            SELECT @q10 = [qchar]
            FROM [#qtemp]
            WHERE [qnum] = 10;
            TRUNCATE TABLE [#qtemp];
            EXEC(@q1 + @q2 + @q3 + @q4 + @q5 + @q6 + @q7 + @q8 + @q9 + @q10 + @cmd);
            SELECT @cmd = @nextcmd
                  ,@useq = 1;
        END;
        FETCH @local_cursor
        INTO @name;
    END; /* while FETCH_SUCCESS */
    CLOSE @local_cursor;
    IF @worker_type = 1 DEALLOCATE [hCForEachDatabase];
    ELSE DEALLOCATE [hCForEachTable];

    RETURN 0;
END;

GO

