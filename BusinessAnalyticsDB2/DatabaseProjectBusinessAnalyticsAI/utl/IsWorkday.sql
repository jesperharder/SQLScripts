CREATE FUNCTION [utl].[IsWorkday]
(
    @date date
   ,@language int
)
RETURNS tinyint
AS
BEGIN
    DECLARE @r int;
    SET @r = @@DATEFIRST - 1 + DATEPART(WEEKDAY, @date);
    -- Loerdag eller Soendag ?   
    IF(@r = 6) OR (@r = 7)SET @r = 1;
    ELSE SELECT @r = [IsHoliday] FROM [utl].IsDanishHoliday(@date, @language);
    RETURN ABS(@r - 1);
END;

GO

