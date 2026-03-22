CREATE FUNCTION [utl].[WorkDayOfMonth]
(
    @date date
   ,@langauge int
)
RETURNS int
AS
BEGIN
    DECLARE @WorkDayOfMonth int
           ,@WorkDay int;

    IF DATEPART(DW, @date) IN ( 6, 7 )SET @WorkDay = 0;
    ELSE SET @WorkDay = [utl].[IsWorkday](@date, @langauge);

    SELECT @WorkDayOfMonth = SUM(IIF([WorkingDay] = 'Yes', 1, 0))
    FROM [dim].[Date]
    WHERE [Date] >= DATEADD(DAY, (DAY(@date) - 1) * -1, @date)
    AND   [Date] <= @date
    AND   [WorkingDay] = 'Yes';

    IF @WorkDayOfMonth IS NULL SET @WorkDayOfMonth = 0;

    SET @WorkDayOfMonth = @WorkDayOfMonth + @WorkDay;

    IF @WorkDayOfMonth = 0 SET @WorkDayOfMonth = 1;

    RETURN @WorkDayOfMonth;
END;

GO

