CREATE PROCEDURE [data_validation].[RunSuite]
    @ValidationGroup NVARCHAR(20) = NULL,
    @ExecutedBy NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ValidationCode NVARCHAR(128);

    DECLARE SuiteCursor CURSOR LOCAL FAST_FORWARD FOR
        SELECT tp.[ValidationCode]
        FROM [data_validation].[TablePair] AS tp
        WHERE tp.[IsActive] = 1
          AND (@ValidationGroup IS NULL OR tp.[ValidationGroup] = @ValidationGroup)
        ORDER BY tp.[ValidationGroup], tp.[ValidationCode];

    OPEN SuiteCursor;
    FETCH NEXT FROM SuiteCursor INTO @ValidationCode;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC [data_validation].[RunTablePair]
            @ValidationCode = @ValidationCode,
            @ExecutedBy = @ExecutedBy;

        FETCH NEXT FROM SuiteCursor INTO @ValidationCode;
    END;

    CLOSE SuiteCursor;
    DEALLOCATE SuiteCursor;

    SELECT *
    FROM [data_validation].[vwLatestStatus]
    WHERE @ValidationGroup IS NULL OR [ValidationGroup] = @ValidationGroup
    ORDER BY [ValidationGroup], [ValidationCode];
END


GO
