CREATE   PROCEDURE [dim].[PopulateDateNew]
(
    @FromDate date = '20080101'
   ,@ToDate date = '20301231'
)
AS
BEGIN
    SET NOCOUNT ON;

    /* Make sure to use DK weekstart */
    SET DATEFIRST 1;

    BEGIN TRY

        -- Get the current transaction count
        DECLARE @TranCounter int = @@TRANCOUNT
               ,@SavePoint nvarchar(32) = CAST(@@PROCID AS nvarchar(20)) + N'_' + CAST(@@NESTLEVEL AS nvarchar(2));

        -- Decide to join existing transaction or start new
        IF @TranCounter > 0 SAVE TRANSACTION @SavePoint;
        ELSE BEGIN TRANSACTION;

        TRUNCATE TABLE [dim].[Date];

        BEGIN
            DECLARE @p_date date;
            DECLARE @DateKey int;
            DECLARE @Year nvarchar(4);
            DECLARE @Monthnumber nchar(2);
            DECLARE @YearMonthnumber nvarchar(7);
            DECLARE @YearMonthShort nvarchar(8);
            DECLARE @MonthNameShort nvarchar(8);
            DECLARE @MonthNameLong nvarchar(15);
            DECLARE @DayOfWeekNumber nchar(1);
            DECLARE @DayOfWeek nvarchar(10);
            DECLARE @DayOfWeekShort nvarchar(3);
            DECLARE @Week nchar(2);
            DECLARE @LastDateOfWeekUS date;
            DECLARE @Quarter nchar(2);
            DECLARE @YearQuarter nvarchar(7);
            DECLARE @YearWeek nvarchar(8);
            DECLARE @WeekNo nchar(2);
            DECLARE @YYMM nvarchar(6);
            DECLARE @BudgetMD date;
            DECLARE @EOMONTH date;

            /* Set start date and End date */
            SET @p_date = @FromDate;

            WHILE @p_date <= @ToDate
            BEGIN

                SET @DateKey = YEAR(@p_date) * 10000 + MONTH(@p_date) * 100 + DAY(@p_date);
                SET @Year = CAST(YEAR(@p_date) AS nvarchar(4));
                SET @Monthnumber = FORMAT(@p_date, N'MM', N'en-US');
                SET @YearMonthnumber = FORMAT(@p_date, N'yyyy/MM', N'en-US');
                SET @YearMonthShort = FORMAT(@p_date, N'yyyy/MMM', N'en-US');
                SET @MonthNameShort = FORMAT(@p_date, N'MMM', N'en-US');
                SET @MonthNameLong = FORMAT(@p_date, N'MM - MMMM', N'en-US');
                SET @DayOfWeekNumber = CAST(DATEPART(WEEKDAY, @p_date) - 1 AS nvarchar(1));
                SET @DayOfWeek = FORMAT(@p_date, N'dddd', N'en-US');
                SET @DayOfWeekShort = FORMAT(@p_date, N'ddd', N'en-US');
                SET @Week = CAST(DATEPART(ISO_WEEK, @p_date) AS char(2));
                SET @LastDateOfWeekUS = DATEADD(DAY, -DATEPART(dw, @p_date) + 6, @p_date);
                SET @Quarter = CONCAT(N'Q', DATEPART(q, @p_date));
                SET @YearQuarter = CONCAT(FORMAT(@p_date, N'yyyy/', N'en-US'), N'Q', DATEPART(q, @p_date));
                SET @YearWeek = CONCAT(FORMAT(@p_date, N'yyyy/W', N'en-US'), DATEPART(wk, @p_date) - 1);
                SET @WeekNo = CAST(DATEPART(ISO_WEEK, @p_date) AS nvarchar(2));
                SET @YYMM = FORMAT(@p_date, N'yyyyMM', N'en-US');
                SET @BudgetMD = EOMONTH(@p_date, 0);
                SET @EOMONTH = EOMONTH(@p_date, 0);

                INSERT INTO [dim].[Date]
                (
                    [DateKey]
                   ,[Date]
                   ,[Year]
                   ,[Monthnumber]
                   ,[YearMonthnumber]
                   ,[YearMonthShort]
                   ,[MonthNameShort]
                   ,[MonthNameLong]
                   ,[DayOfWeekNumber]
                   ,[DayOfWeek]
                   ,[DayOfWeekShort]
                   ,[Week]
                   ,[LastDateOfWeekUS]
                   ,[Quarter]
                   ,[YearQuarter]
                   ,[YearWeek]
                   ,[WeekNo]
                   ,[YYMM]
                   ,[BudgetMD]
                   ,[EO-MONTH]
                )
                VALUES
                (
                    @DateKey, @p_date, @Year, @Monthnumber, @YearMonthnumber, @YearMonthShort, @MonthNameShort, @MonthNameLong, @DayOfWeekNumber, @DayOfWeek, @DayOfWeekShort, @Week, @LastDateOfWeekUS, @Quarter, @YearQuarter, @YearWeek
                   ,@WeekNo, @YYMM, @BudgetMD, @EOMONTH
                );

                SET @p_date = DATEADD(D, 1, @p_date);
            END;

            ALTER INDEX [PK_Date] ON [dim].[Date] REBUILD;

        END;

        IF @TranCounter = 0 COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH

        IF @TranCounter = 0 ROLLBACK TRANSACTION;
        ELSE IF XACT_STATE() = 1 ROLLBACK TRANSACTION @SavePoint;
        ELSE IF XACT_STATE() = -1 ROLLBACK TRANSACTION;

        THROW;
        RETURN 1;

    END CATCH;
END;

GO

