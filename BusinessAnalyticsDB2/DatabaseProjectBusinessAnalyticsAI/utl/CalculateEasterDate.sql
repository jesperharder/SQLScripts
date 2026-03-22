CREATE FUNCTION [utl].[CalculateEasterDate]
(
    @eYear int
)
RETURNS datetime
AS
BEGIN
    /* 
        Fischer Lexikon Astronomie, p. 50:
        Algorithm of C.F. Gau (1777-1855),
        for 1583 <= eyear <= 2299  
        */

    DECLARE @m int = 0;
    DECLARE @n int = 0;
    DECLARE @a int;
    DECLARE @b int;
    DECLARE @c int;
    DECLARE @d int;
    DECLARE @e int;
    DECLARE @eDay int;
    DECLARE @eMonth int;
    /* Kan tilfoejes hvis MsSQL senere understoetter flere aar
           if (eYear <= 1699) @m=22, n=2 else
        */
    IF(@eYear <= 1799)
    BEGIN
        SET @m = 23;
        SET @n = 3;
    END;
    ELSE IF(@eYear <= 1899)
    BEGIN
        SET @m = 23;
        SET @n = 4;
    END;
    ELSE IF(@eYear <= 2099)
    BEGIN
        SET @n = 5;
        SET @m = 24;
    END;
    ELSE IF(@eYear <= 2199)
    BEGIN
        SET @m = 24;
        SET @n = 6;
    END;
    ELSE IF(@eYear <= 2299)
    BEGIN
        SET @m = 25;
        SET @n = 0;
    END;
    SET @a = @eYear % 19;
    SET @b = @eYear % 4;
    SET @c = @eYear % 7;

    SET @d = ((19 * @a) + @m) % 30;
    SET @e = ((2 * @b) + (4 * @c) + (6 * @d) + @n) % 7;
    SET @eDay = 22 + @d + @e;
    SET @eMonth = 4;
    IF(@eDay <= 31)
    BEGIN
        SET @eMonth = 3;
    END;
    ELSE IF((@d = 28) AND (@e = 6) AND (@a > 10))
    BEGIN
        SET @eDay = 18;
    END;
    ELSE IF((@d = 29) AND (@e = 6))
    BEGIN
        SET @eDay = 19;
    END;
    ELSE BEGIN
        SET @eDay = @d + @e - 9;
    END;

    RETURN DATETIMEFROMPARTS(@eYear, @eMonth, @eDay, 0, 0, 0, 0);
END;

GO

