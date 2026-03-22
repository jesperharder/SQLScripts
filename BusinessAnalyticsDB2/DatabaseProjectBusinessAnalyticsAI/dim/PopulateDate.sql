CREATE PROCEDURE [dim].[PopulateDate]
(
    @FromDate date = '20000101'
   ,@ToDate date = '20301231'
   ,@Language int = 2 -- 1 = Dansk, 2 = Engelsk
   ,@FiscalStartMonth int = 8
)
AS
BEGIN
    SET NOCOUNT ON;

    /* Make sure to use DK weekstart */
    SET DATEFIRST 1;
    IF @Language = 1 SET LANGUAGE [Danish];
    ELSE IF @Language = 2 SET LANGUAGE [English];

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
            DECLARE @DayName varchar(10);
            DECLARE @DayOfWeek int;
            DECLARE @MonthName varchar(10);
            DECLARE @MonthShortName varchar(3);
            DECLARE @MonthOfQuarter int;
            DECLARE @YearName varchar(4);
            DECLARE @QuarterName varchar(10);
            DECLARE @QuarterDate date;
            DECLARE @WeekNumber int;
            DECLARE @WeekName varchar(10);
            DECLARE @Helligdag int;
            DECLARE @Arbejdsdag int;
            DECLARE @FiscalYear date;
            DECLARE @FiscalYearChangeDate date = DATEFROMPARTS(2021, 8, 1);
            DECLARE @FiscalStartMonthOld int = 11;
            DECLARE @FiscalYearName varchar(20);
            DECLARE @FiscalYearNameShort varchar(15);
            DECLARE @FiscalMonthNumber smallint;
            DECLARE @FiscalQuarter smallint;
            DECLARE @FiscalQuarterDate date;
            DECLARE @FiscalQuarterName varchar(18);
            DECLARE @WeekYear int;
            DECLARE @CalendarText varchar(15);
            DECLARE @DayText varchar(15);
            DECLARE @MonthText varchar(15);
            DECLARE @QuarterText varchar(15);
            DECLARE @QuarterTextShort varchar(15);
            DECLARE @FiscalQuarterText varchar(50);
            DECLARE @FiscalQuarterTextShort varchar(15);
            DECLARE @FiscalYearNameText varchar(50);
            DECLARE @FiscalYearNameShortText varchar(15);
            DECLARE @UnknownDateText varchar(50);
            DECLARE @BeforeDateText varchar(50);
            DECLARE @AfterDateText varchar(50);

            IF @Language = 1
            BEGIN
                SET @CalendarText = 'Kalender';
                SET @DayText = 'Dag';
                SET @MonthText = 'Måned';
                SET @QuarterText = 'Kvartal';
                SET @QuarterTextShort = 'K';
                SET @FiscalQuarterText = 'Regnskabskvartal';
                SET @FiscalQuarterTextShort = 'RK';
                SET @FiscalYearNameText = 'Regnskabsår';
                SET @FiscalYearNameShortText = 'RÅ';
                SET @UnknownDateText = 'Ukendt dag';
                SET @BeforeDateText = 'Før Dato-dimensionens begyndelse';
                SET @AfterDateText = 'Efter Dato-dimensionens begyndelse';
            END;
            ELSE IF @Language = 2
            BEGIN
                SET @CalendarText = 'Calendar';
                SET @DayText = 'Day';
                SET @MonthText = 'Month';
                SET @QuarterText = 'Quarter';
                SET @QuarterTextShort = 'Q';
                SET @FiscalQuarterText = 'FiscalQuarter';
                SET @FiscalQuarterTextShort = 'FQ';
                SET @FiscalYearNameText = 'Fiscal Year';
                SET @FiscalYearNameShortText = 'FY';
                SET @UnknownDateText = 'Unknown date';
                SET @BeforeDateText = 'Before beginning of date dimension';
                SET @AfterDateText = 'After end of date dimension';
            END;

            /* Saet begyndelsesdato og slutdato */
            SET @p_date = @FromDate; --'2009 jan 01' -- Startdato

            WHILE @p_date <= @ToDate -- Slutdato

            BEGIN

                /* Fiscal Year logic */
                IF @p_date < @FiscalYearChangeDate
                BEGIN

                    SET @FiscalYear = DATEFROMPARTS(YEAR(@p_date), @FiscalStartMonthOld, 1);

                    IF MONTH(@p_date) < @FiscalStartMonthOld
                    BEGIN
                        SET @FiscalYear = DATEADD(yy, -1, @FiscalYear);
                        SET @FiscalYearName = @FiscalYearNameText + ' ' + CAST((DATEPART(yyyy, @p_date)) AS varchar(4));
                        SET @FiscalYearNameShort = @FiscalYearNameShortText + SUBSTRING(CAST((DATEPART(yyyy, @p_date)) AS varchar(4)), 3, 2);
                        /*Gammel Logik SET @FiscalYearName = CAST((DATEPART(yyyy, @p_date)-1) AS VARCHAR(4)) + '/' + CAST((DATEPART(yyyy, @p_date)) AS VARCHAR(4))*/
                        SET @FiscalMonthNumber = 12 + (MONTH(@p_date) - (@FiscalStartMonthOld - 1));
                    END;
                    ELSE
                    BEGIN
                        SET @FiscalYear = @FiscalYear;
                        SET @FiscalYearName = @FiscalYearNameText + ' ' + CAST((DATEPART(yyyy, @p_date) + 1) AS varchar(4));
                        SET @FiscalYearNameShort = @FiscalYearNameShortText + SUBSTRING(CAST((DATEPART(yyyy, @p_date) + 1) AS varchar(4)), 3, 2);
                        /*SET @FiscalYearName = CAST((DATEPART(yyyy, @p_date)) AS VARCHAR(4)) + '/' + CAST((DATEPART(yyyy, @p_date)+1) AS VARCHAR(4))*/
                        SET @FiscalMonthNumber = MONTH(@p_date) - (@FiscalStartMonthOld - 1);
                    END;

                    IF @FiscalMonthNumber <= 3 SET @FiscalQuarter = 1;
                    ELSE IF @FiscalMonthNumber <= 6 SET @FiscalQuarter = 2;
                    ELSE IF @FiscalMonthNumber <= 9 SET @FiscalQuarter = 3;
                    ELSE SET @FiscalQuarter = 4;

                    IF @FiscalMonthNumber <= 3
                        SET @FiscalQuarterDate = DATEFROMPARTS(YEAR(@FiscalYear), 1, 1);
                    ELSE IF @FiscalMonthNumber <= 6
                        SET @FiscalQuarterDate = DATEFROMPARTS(YEAR(@FiscalYear), 4, 1);
                    ELSE IF @FiscalMonthNumber <= 9
                        SET @FiscalQuarterDate = DATEFROMPARTS(YEAR(@FiscalYear), 7, 1);
                    ELSE SET @FiscalQuarterDate = DATEFROMPARTS(YEAR(@FiscalYear), 10, 1);

                    SET @FiscalQuarterName = @FiscalQuarterText + ' ' + CAST(@FiscalQuarter AS varchar(1));
                END;
                ELSE
                BEGIN

                    SET @FiscalYear = DATEFROMPARTS(YEAR(@p_date), @FiscalStartMonth, 1);

                    IF MONTH(@p_date) < @FiscalStartMonth
                    BEGIN
                        SET @FiscalYear = DATEADD(yy, -1, @FiscalYear);
                        SET @FiscalYearName = @FiscalYearNameText + ' ' + CAST((DATEPART(yyyy, @p_date)) AS varchar(4));
                        SET @FiscalYearNameShort = @FiscalYearNameShortText + SUBSTRING(CAST((DATEPART(yyyy, @p_date)) AS varchar(4)), 3, 2);
                        /*Gammel Logik SET @FiscalYearName = CAST((DATEPART(yyyy, @p_date)-1) AS VARCHAR(4)) + '/' + CAST((DATEPART(yyyy, @p_date)) AS VARCHAR(4))*/
                        SET @FiscalMonthNumber = 12 + (MONTH(@p_date) - (@FiscalStartMonth - 1));
                    END;
                    ELSE
                    BEGIN
                        SET @FiscalYear = @FiscalYear;
                        SET @FiscalYearName = @FiscalYearNameText + ' ' + CAST((DATEPART(yyyy, @p_date) + 1) AS varchar(4));
                        SET @FiscalYearNameShort = @FiscalYearNameShortText + SUBSTRING(CAST((DATEPART(yyyy, @p_date) + 1) AS varchar(4)), 3, 2);
                        /*SET @FiscalYearName = CAST((DATEPART(yyyy, @p_date)) AS VARCHAR(4)) + '/' + CAST((DATEPART(yyyy, @p_date)+1) AS VARCHAR(4))*/
                        SET @FiscalMonthNumber = MONTH(@p_date) - (@FiscalStartMonth - 1);
                    END;

                    IF @FiscalMonthNumber <= 3 SET @FiscalQuarter = 1;
                    ELSE IF @FiscalMonthNumber <= 6 SET @FiscalQuarter = 2;
                    ELSE IF @FiscalMonthNumber <= 9 SET @FiscalQuarter = 3;
                    ELSE SET @FiscalQuarter = 4;

                    IF @FiscalMonthNumber <= 3
                        SET @FiscalQuarterDate = DATEFROMPARTS(YEAR(@FiscalYear), 1, 1);
                    ELSE IF @FiscalMonthNumber <= 6
                        SET @FiscalQuarterDate = DATEFROMPARTS(YEAR(@FiscalYear), 4, 1);
                    ELSE IF @FiscalMonthNumber <= 9
                        SET @FiscalQuarterDate = DATEFROMPARTS(YEAR(@FiscalYear), 7, 1);
                    ELSE SET @FiscalQuarterDate = DATEFROMPARTS(YEAR(@FiscalYear), 10, 1);

                    SET @FiscalQuarterName = @FiscalQuarterText + ' ' + CAST(@FiscalQuarter AS varchar(1));

                END;

                SET @YearName = CAST(YEAR(@p_date) AS varchar(4));

                SET @DayOfWeek = DATEPART(dw, @p_date);

                SET @DayName = UPPER(SUBSTRING(DATENAME(DW, @p_date), 1, 1)) + SUBSTRING(DATENAME(DW, @p_date), 2, LEN(DATENAME(DW, @p_date)) - 1);

                SET @MonthName = UPPER(SUBSTRING(DATENAME(MM, @p_date), 1, 1)) + SUBSTRING(DATENAME(MM, @p_date), 2, LEN(DATENAME(MM, @p_date)) - 1);

                SET @MonthShortName = UPPER(SUBSTRING(DATENAME(MM, @p_date), 1, 3));

                IF DATEPART(mm, @p_date) IN ( 1, 4, 7, 10 )SET @MonthOfQuarter = 1;
                ELSE IF DATEPART(mm, @p_date) IN ( 2, 5, 8, 11 )SET @MonthOfQuarter = 2;
                ELSE IF DATEPART(mm, @p_date) IN ( 3, 6, 9, 12 )SET @MonthOfQuarter = 3;

                IF DATEPART(qq, @p_date) = 1 SET @QuarterName = '1. ' + @QuarterText;
                ELSE IF DATEPART(qq, @p_date) = 2 SET @QuarterName = '2. ' + @QuarterText;
                ELSE IF DATEPART(qq, @p_date) = 3 SET @QuarterName = '3. ' + @QuarterText;
                ELSE IF DATEPART(qq, @p_date) = 4 SET @QuarterName = '4. ' + @QuarterText;

                IF DATEPART(qq, @p_date) = 1 SET @QuarterDate = @YearName + '-01-01';
                ELSE IF DATEPART(qq, @p_date) = 2 SET @QuarterDate = @YearName + '-04-01';
                ELSE IF DATEPART(qq, @p_date) = 3 SET @QuarterDate = @YearName + '-07-01';
                ELSE IF DATEPART(qq, @p_date) = 4 SET @QuarterDate = @YearName + '-10-01';

                IF DATEPART(dw, @p_date) IN ( 6, 7 )SET @Helligdag = 1;
                ELSE
                    SELECT @Helligdag = [IsHoliday]
                    FROM [utl].[IsDanishHoliday](@p_date, @Language);

                IF DATEPART(dw, @p_date) IN ( 6, 7 )SET @Arbejdsdag = 0;
                ELSE SET @Arbejdsdag = [utl].[IsWorkday](@p_date, @Language);

                SET @WeekNumber = DATEPART(ISO_WEEK, @p_date);
                /* Kommenteret ud, da ugenr regnede forkert */
                --CASE
                --	-- Exception where @p_date is part of week 52 (or 53) of the previous year
                --	WHEN @p_date < 
                --		CASE (DATEPART(dw, '04-01-' + CAST(YEAR(@p_date) AS CHAR(4))) + @@DATEFIRST - 1) % 7
                --			WHEN 1 THEN '04-01-' + CAST(YEAR(@p_date) AS CHAR(4))
                --			WHEN 2 THEN DATEADD(d, -1, '04-01-' + CAST(YEAR(@p_date) AS CHAR(4)))
                --			WHEN 3 THEN DATEADD(d, -2, '04-01-' + CAST(YEAR(@p_date) AS CHAR(4)))
                --			WHEN 4 THEN DATEADD(d, -3, '04-01-' + CAST(YEAR(@p_date) AS CHAR(4)))
                --			WHEN 5 THEN DATEADD(d, -4, '04-01-' + CAST(YEAR(@p_date) AS CHAR(4)))
                --			WHEN 6 THEN DATEADD(d, -5, '04-01-' + CAST(YEAR(@p_date) AS CHAR(4)))
                --			ELSE DATEADD(d, -6, '04-01-' + CAST(YEAR(@p_date) AS CHAR(4)))
                --		END
                --	THEN
                --		(DATEDIFF(d,
                --			CASE (DATEPART(dw, '04-01-' + CAST(YEAR(@p_date)-1 AS CHAR(4))) + @@DATEFIRST - 1) % 7
                --				WHEN 1 THEN '04-01-' + CAST(YEAR(@p_date)-1 AS CHAR(4))
                --				WHEN 2 THEN DATEADD(d, -1, '04-01-' + CAST(YEAR(@p_date)-1 AS CHAR(4)))
                --				WHEN 3 THEN DATEADD(d, -2, '04-01-' + CAST(YEAR(@p_date)-1 AS CHAR(4)))
                --				WHEN 4 THEN DATEADD(d, -3, '04-01-' + CAST(YEAR(@p_date)-1 AS CHAR(4)))
                --				WHEN 5 THEN DATEADD(d, -4, '04-01-' + CAST(YEAR(@p_date)-1 AS CHAR(4)))
                --				WHEN 6 THEN DATEADD(d, -5, '04-01-' + CAST(YEAR(@p_date)-1 AS CHAR(4)))
                --				ELSE DATEADD(d, -6, '04-01-' + CAST(YEAR(@p_date)-1 AS CHAR(4)))
                --			END,@p_date) / 7) + 1

                ---- Exception where @p_date is part of week 1 of the following year
                --	WHEN @p_date >= 
                --		CASE (DATEPART(dw, '04-01-' + CAST(YEAR(@p_date)+1 AS CHAR(4))) + @@DATEFIRST - 1) % 7
                --			WHEN 1 THEN '04-01-' + CAST(YEAR(@p_date)+1 AS CHAR(4))
                --			WHEN 2 THEN DATEADD(d, -1, '04-01-' + CAST(YEAR(@p_date)+1 AS CHAR(4)))
                --			WHEN 3 THEN DATEADD(d, -2, '04-01-' + CAST(YEAR(@p_date)+1 AS CHAR(4)))
                --			WHEN 4 THEN DATEADD(d, -3, '04-01-' + CAST(YEAR(@p_date)+1 AS CHAR(4)))
                --			WHEN 5 THEN DATEADD(d, -4, '04-01-' + CAST(YEAR(@p_date)+1 AS CHAR(4)))
                --			WHEN 6 THEN DATEADD(d, -5, '04-01-' + CAST(YEAR(@p_date)+1 AS CHAR(4)))
                --			ELSE DATEADD(d, -6, '04-01-' + CAST(YEAR(@p_date)+1 AS CHAR(4)))
                --		END
                --	THEN 1
                --	ELSE
                ---- Calculate the ISO week number for all dates that are not part of the exceptions above
                --		(DATEDIFF(d,
                --			CASE (DATEPART(dw, '04-01-' + CAST(YEAR(@p_date) AS CHAR(4))) + @@DATEFIRST - 1) % 7
                --				WHEN 1 THEN '04-01-' + CAST(YEAR(@p_date) AS CHAR(4))
                --				WHEN 2 THEN DATEADD(d, -1, '04-01-' + CAST(YEAR(@p_date) AS CHAR(4)))
                --				WHEN 3 THEN DATEADD(d, -2, '04-01-' + CAST(YEAR(@p_date) AS CHAR(4)))
                --				WHEN 4 THEN DATEADD(d, -3, '04-01-' + CAST(YEAR(@p_date) AS CHAR(4)))
                --				WHEN 5 THEN DATEADD(d, -4, '04-01-' + CAST(YEAR(@p_date) AS CHAR(4)))
                --				WHEN 6 THEN DATEADD(d, -5, '04-01-' + CAST(YEAR(@p_date) AS CHAR(4)))
                --				ELSE DATEADD(d, -6, '04-01-' + CAST(YEAR(@p_date) AS CHAR(4)))
                --			END, @p_date) / 7) + 1
                --END

                IF @Language = 1 SET @WeekName = 'Uge ' + CAST(@WeekNumber AS varchar(2));
                ELSE IF @Language = 2 SET @WeekName = 'Week ' + CAST(@WeekNumber AS varchar(2));

                SET @WeekYear = DATEPART(YEAR, DATEADD(DAY, 4 - DATEPART(WEEKDAY, @p_date), @p_date)); -- Year of thursday in the week

                INSERT INTO [dim].[Date]
                (
                    [DW_SK_Date]
                   ,[Date]
                   ,[DayName]
                   ,[DayNameShort]
                   ,[Year]
                   ,[YearName]
                   ,[YearNameShort]
                   ,[YearNumber]
                   ,[Quarter]
                   ,[QuarterName]
                   ,[QuarterNameShort]
                   ,[Month]
                   ,[MonthEnd]
                   ,[MonthName]
                   ,[MonthNameShort]
                   ,[Week]
                   ,[WeekName]
                   ,[WeekNameShort]
                   ,[DayOfYear]
                   ,[DayOfYearName]
                   ,[DayOfYearNameShort]
                   ,[DayOfQuarter]
                   ,[DayOfQuarterName]
                   ,[DayOfQuarterNameShort]
                   ,[DayOfMonth]
                   ,[DayOfMonthName]
                   ,[DayOfMonthNameShort]
                   ,[DayOfWeek]
                   ,[DayOfWeekName]
                   ,[DayOfWeekNameShort]
                   ,[WeekdayName]
                   ,[WeekdayNameShort]
                   ,[WeekYear]
                   ,[WeekOfYear]
                   ,[WeekOfYearName]
                   ,[WeekOfYearNameShort]
                   ,[MonthOfYear]
                   ,[MonthOfYearName]
                   ,[MonthOfYearNameShort]
                   ,[MonthOfQuarter]
                   ,[MonthOfQuarterName]
                   ,[MonthOfQuarterNameShort]
                   ,[QuarterOfYear]
                   ,[QuarterOfYearName]
                   ,[QuarterOfYearNameShort]
                   ,[Holiday]
                   ,[HolidayName]
                   ,[WorkingDay]
                   ,[WorkingDayOfMonth]
                   ,[FiscalYear]
                   ,[FiscalYearName]
                   ,[FiscalYearNameShort]
                   ,[MonthOfFiscalYear]
                   ,[MonthNameOfFiscalYear]
                   ,[QuarterOfFiscalYear]
                   ,[QuarterOfFiscalYearName]
                   ,[QuarterOfFiscalYearNameShort]
                   ,[FiscalQuarterDate]
                )
                SELECT CAST(CONVERT(varchar(8), @p_date, 112) AS int) AS [DW_SK_Date] /* St DateID som int med formatet yyyymmdd */
                      ,@p_date AS [Date]
                      ,RTRIM(@DayName) + ', ' + CAST(DAY(@p_date) AS varchar(2)) + ' ' + @MonthName + ' ' + @YearName AS [DayName]
                      ,RIGHT('0' + CAST(DAY(@p_date) AS varchar(2)), 2) + '-' + RIGHT('0' + CAST(MONTH(@p_date) AS varchar(2)), 2) + '-' + CAST(YEAR(@p_date) AS varchar(4)) AS [DayNameShort]
                      ,CAST(CAST(YEAR(@p_date) AS varchar(4)) + '-01-01' AS date) AS [Year]
                      ,@CalendarText + ' ' + @YearName AS [YearName]
                      ,@YearName AS [YearNameShort]
                      ,YEAR(@p_date) AS [YearNumber]
                      ,@QuarterDate AS [Quarter]
                      ,@QuarterName + ' ' + @YearName AS [QuarterName]
                      ,@QuarterTextShort + CAST(DATEPART(qq, @p_date) AS varchar(2)) AS [QuarterNameShort]
                      ,@YearName + ' ' + @MonthShortName + ' 01' AS [Month]
                      ,EOMONTH(CAST(@YearName + ' ' + @MonthShortName + ' 01' AS date)) AS [MonthEnd]
                      ,@MonthName + ' ' + @YearName AS [MonthName]
                      ,SUBSTRING(@MonthName, 1, 3) AS [MonthNameShort]
                      ,CASE
                           WHEN YEAR(@p_date) > YEAR(DATEADD(DAY, -DAY(DATEADD(DAY, -1, DATEPART(WEEKDAY, @p_date))), @p_date)) THEN
                               CAST('01-01-' + CAST(YEAR(@p_date) AS varchar(4)) AS date)
                           ELSE
                      (DATEADD(DAY, -(DATEPART(DW, @p_date) - 1), @p_date))
                       END AS [Week]
                      ,@WeekName + ', ' + CAST(@WeekYear AS varchar(4)) AS [WeekName]
                      ,@WeekNumber AS [WeekNameShort]
                      ,DATEPART(dy, @p_date) AS [DayOfYear]
                      ,@DayText + ' ' + RTRIM(CAST(DATEPART(dy, @p_date) AS varchar(3))) AS [DayOfYearName]
                      ,RTRIM(CAST(DATEPART(dy, @p_date) AS varchar(3))) AS [DayOfYearNameShort]
                      ,DATEDIFF(dd, DATEADD(qq, DATEDIFF(QQ, 0, @p_date), -1), @p_date) AS [DayOfQuarter] --Dag af kvartal int
                      ,@DayText + ' ' + CAST(DATEDIFF(dd, DATEADD(qq, DATEDIFF(QQ, 0, @p_date), -1), @p_date) AS varchar(2)) AS [DayOfQuarterName] --Dag af kvartal varchar(6)
                      ,CAST(DATEDIFF(dd, DATEADD(qq, DATEDIFF(QQ, 0, @p_date), -1), @p_date) AS varchar(2)) AS [DayOfQuarterNameShort]
                      ,DATEPART(dd, @p_date) AS [DayOfMonth]
                      ,@DayText + ' ' + CAST(DATEPART(dd, @p_date) AS varchar(2)) AS [DayOfMonthName]
                      ,CAST(DATEPART(dd, @p_date) AS varchar(2)) AS [DayOfMonthNameShort]
                      ,@DayOfWeek AS [DayOfWeek]
                      ,@DayText + ' ' + CAST(@DayOfWeek AS varchar(1)) AS [DayOfWeekName]
                      ,CAST(@DayOfWeek AS varchar(1)) AS [DayOfWeekNameShort]
                      ,@DayName AS [WeekdayName]
                      ,SUBSTRING(@DayName, 1, 3) AS [WeekdayNameShort]
                      ,@WeekYear AS [WeekYear]
                      ,@WeekNumber AS [WeekOfYear] --DATEPART(ww, @p_date)
                      ,@WeekName AS [WeekOfYearName]
                      ,@WeekNumber AS [WeekOfYearNameShort]
                      ,DATEPART(mm, @p_date) AS [MonthOfYear]
                      ,@MonthName AS [MonthOfYearName]
                      ,SUBSTRING(@MonthName, 1, 3) AS [MonthOfYearNameShort]
                      ,@MonthOfQuarter AS [MonthOfQuarter]
                      ,@MonthText + ' ' + CAST(@MonthOfQuarter AS varchar(1)) AS [MonthOfQuarterName]
                      ,CAST(@MonthOfQuarter AS varchar(1)) AS [MonthOfQuarterNameShort]
                      ,DATEPART(qq, @p_date) AS [QuarterOfYear]
                      ,@QuarterName AS [QuarterOfYearName]
                      ,@QuarterTextShort + CAST(DATEPART(qq, @p_date) AS varchar(2)) AS [QuarterOfYearNameShort]
                      ,IIF(@Helligdag = 1, 'Yes', 'No') AS [Holyday]
                      ,(
                           SELECT [HolidayName] FROM [utl].[IsDanishHoliday](@p_date, @Language)
                       ) AS [HolidayName]
                      ,IIF(@Arbejdsdag = 1, 'Yes', 'No') AS [WorkingDay]
                      ,[utl].[WorkDayOfMonth](@p_date, @Language) AS [WorkingDayOfMonth]
                      ,@FiscalYear AS [FiscalYear]
                      ,@FiscalYearName AS [FiscalYearName]
                      ,@FiscalYearNameShort AS [FiscalYearNameShort]
                      ,@FiscalMonthNumber AS [MonthOfFiscalYear]
                      ,CONCAT(SUBSTRING(@MonthName, 1, 3), ' ''', RIGHT(@YearName, 2)) AS [MonthNameOfFiscalYear]
                      ,@FiscalQuarter AS [QuarterOfFiscalYear]
                      ,@FiscalQuarterName AS [QuarterOfFiscalYearName]
                      ,CONCAT(@FiscalQuarterTextShort, CAST(@FiscalQuarter AS varchar(1)), ', ', @FiscalYearNameShort) AS [QuarterOfFiscalYearNameShort]
                      ,@FiscalQuarterDate AS [FiscalQuarterDate];

                SET @p_date = DATEADD(D, 1, @p_date);
            END;

            /* Insert Unknown and Without members in Alder dimension, if they are not already there */
            MERGE [dim].[Date] AS [d]
            USING
            (
                SELECT -1 AS [DW_SK_Date]
                      ,'19000101' AS [Date]
                      ,@UnknownDateText AS [DayName]
                      ,@UnknownDateText AS [DayNameShort]
                      ,'19000101' AS [Year]
                      ,@UnknownDateText AS [YearName]
                      ,@UnknownDateText AS [YearNameShort]
                      ,-1 AS [YearNumber]
                      ,'19000101' AS [Quarter]
                      ,@UnknownDateText AS [QuarterName]
                      ,@UnknownDateText AS [QuarterNameShort]
                      ,'19000101' AS [Month]
                      ,'19000131' AS [MonthEnd]
                      ,@UnknownDateText AS [MonthName]
                      ,@UnknownDateText AS [MonthNameShort]
                      ,'19000101' AS [Week]
                      ,@UnknownDateText AS [WeekName]
                      ,@UnknownDateText AS [WeekNameShort]
                      ,-1 AS [DayOfYear]
                      ,@UnknownDateText AS [DayOfYearName]
                      ,@UnknownDateText AS [DayOfYearNameShort]
                      ,-1 AS [DayOfQuarter]
                      ,@UnknownDateText AS [DayOfQuarterName]
                      ,@UnknownDateText AS [DayOfQuarterNameShort]
                      ,-1 AS [DayOfMonth]
                      ,@UnknownDateText AS [DayOfMonthName]
                      ,@UnknownDateText AS [DayOfMonthNameShort]
                      ,-1 AS [DayOfWeek]
                      ,@UnknownDateText AS [DayOfWeekName]
                      ,@UnknownDateText AS [DayOfWeekNameShort]
                      ,@UnknownDateText AS [WeekdayName]
                      ,@UnknownDateText AS [WeekdayNameShort]
                      ,-1 AS [WeekYear]
                      ,-1 AS [WeekOfYear]
                      ,@UnknownDateText AS [WeekOfYearName]
                      ,@UnknownDateText AS [WeekOfYearNameShort]
                      ,-1 AS [MonthOfYear]
                      ,@UnknownDateText AS [MonthOfYearName]
                      ,@UnknownDateText AS [MonthOfYearNameShort]
                      ,-1 AS [MonthOfQuarter]
                      ,@UnknownDateText AS [MonthOfQuarterName]
                      ,@UnknownDateText AS [MonthOfQuarterNameShort]
                      ,-1 AS [QuarterOfYear]
                      ,@UnknownDateText AS [QuarterOfYearName]
                      ,@UnknownDateText AS [QuarterOfYearNameShort]
                      ,@UnknownDateText AS [Holiday]
                      ,@UnknownDateText AS [HolidayName]
                      ,@UnknownDateText AS [WorkingDay]
                      ,0 AS [WorkingDayOfMonth]
                      ,'19000101' AS [FiscalYear]
                      ,@UnknownDateText AS [FiscalYearName]
                      ,@UnknownDateText AS [FiscalYearNameShort]
                      ,-1 AS [MonthOfFiscalYear]
                      ,@UnknownDateText AS [MonthNameOfFiscalYear]
                      ,-1 AS [QuarterOfFiscalYear]
                      ,@UnknownDateText AS [QuarterOfFiscalYearName]
                      ,@UnknownDateText AS [QuarterOfFiscalYearNameShort]
                      ,'19000101' AS [FiscalQuarterDate]
                UNION
                SELECT -99999999 AS [DW_SK_Date]
                      ,'17530101' AS [Date]
                      ,@BeforeDateText AS [DayName]
                      ,@BeforeDateText AS [DayNameShort]
                      ,'17530101' AS [Year]
                      ,@BeforeDateText AS [YearName]
                      ,@BeforeDateText AS [YearNameShort]
                      ,-9999 AS [YearNumber]
                      ,'17530101' AS [Quarter]
                      ,@BeforeDateText AS [QuarterName]
                      ,@BeforeDateText AS [QuarterNameShort]
                      ,'17530101' AS [Month]
                      ,'17530131' AS [MonthEnd]
                      ,@BeforeDateText AS [MonthName]
                      ,@BeforeDateText AS [MonthNameShort]
                      ,'17530101' AS [Week]
                      ,@BeforeDateText AS [WeekName]
                      ,@BeforeDateText AS [WeekNameShort]
                      ,-9999 AS [DayOfYear]
                      ,@BeforeDateText AS [DayOfYearName]
                      ,@BeforeDateText AS [DayOfYearNameShort]
                      ,-9999 AS [DayOfQuarter]
                      ,@BeforeDateText AS [DayOfQuarterName]
                      ,@BeforeDateText AS [DayOfQuarterNameShort]
                      ,-9999 AS [DayOfMonth]
                      ,@BeforeDateText AS [DayOfMonthName]
                      ,@BeforeDateText AS [DayOfMonthNameShort]
                      ,-9999 AS [DayOfWeek]
                      ,@BeforeDateText AS [DayOfWeekName]
                      ,@BeforeDateText AS [DayOfWeekNameShort]
                      ,@BeforeDateText AS [WeekdayName]
                      ,@BeforeDateText AS [WeekdayNameShort]
                      ,-9999 AS [WeekYear]
                      ,-9999 AS [WeekOfYear]
                      ,@BeforeDateText AS [WeekOfYearName]
                      ,@BeforeDateText AS [WeekOfYearNameShort]
                      ,-9999 AS [MonthOfYear]
                      ,@BeforeDateText AS [MonthOfYearName]
                      ,@BeforeDateText AS [MonthOfYearNameShort]
                      ,-9999 AS [MonthOfQuarter]
                      ,@BeforeDateText AS [MonthOfQuarterName]
                      ,@BeforeDateText AS [MonthOfQuarterNameShort]
                      ,-9999 AS [QuarterOfYear]
                      ,@BeforeDateText AS [QuarterOfYearName]
                      ,@BeforeDateText AS [QuarterOfYearNameShort]
                      ,@BeforeDateText AS [Holiday]
                      ,@BeforeDateText AS [HolidayName]
                      ,@BeforeDateText AS [WorkingDay]
                      ,0 AS [WorkingDayOfMonth]
                      ,'17530101' AS [FiscalYear]
                      ,@BeforeDateText AS [FiscalYearName]
                      ,@BeforeDateText AS [FiscalYearNameShort]
                      ,-9999 AS [MonthOfFiscalYear]
                      ,@BeforeDateText AS [MonthNameOfFiscalYear]
                      ,-9999 AS [QuarterOfFiscalYear]
                      ,@BeforeDateText AS [QuarterOfFiscalYearName]
                      ,@BeforeDateText AS [QuarterOfFiscalYearNameShort]
                      ,'17530101' AS [FiscalQuarterDate]
                UNION
                SELECT 99999999 AS [DW_SK_Date]
                      ,DATEFROMPARTS(YEAR(DATEADD(YEAR, 20, @ToDate)), 12, 31) AS [Date]
                      ,@AfterDateText AS [DayName]
                      ,@AfterDateText AS [DayNameShort]
                      ,DATEFROMPARTS(YEAR(DATEADD(YEAR, 20, @ToDate)), 12, 31) AS [Year]
                      ,@AfterDateText AS [YearName]
                      ,@AfterDateText AS [YearNameShort]
                      ,9999 AS [YearNumber]
                      ,DATEFROMPARTS(YEAR(DATEADD(YEAR, 20, @ToDate)), 12, 31) AS [Quarter]
                      ,@AfterDateText AS [QuarterName]
                      ,@AfterDateText AS [QuarterNameShort]
                      ,DATEFROMPARTS(YEAR(DATEADD(YEAR, 20, @ToDate)), 12, 31) AS [Month]
                      ,DATEFROMPARTS(YEAR(DATEADD(YEAR, 20, @ToDate)), 12, 31) AS [MonthEnd]
                      ,@AfterDateText AS [MonthName]
                      ,@AfterDateText AS [MonthNameShort]
                      ,DATEFROMPARTS(YEAR(DATEADD(YEAR, 20, @ToDate)), 12, 31) AS [Week]
                      ,@AfterDateText AS [WeekName]
                      ,@AfterDateText AS [WeekNameShort]
                      ,9999 AS [DayOfYear]
                      ,@AfterDateText AS [DayOfYearName]
                      ,@AfterDateText AS [DayOfYearNameShort]
                      ,9999 AS [DayOfQuarter]
                      ,@AfterDateText AS [DayOfQuarterName]
                      ,@AfterDateText AS [DayOfQuarterNameShort]
                      ,9999 AS [DayOfMonth]
                      ,@AfterDateText AS [DayOfMonthName]
                      ,@AfterDateText AS [DayOfMonthNameShort]
                      ,9999 AS [DayOfWeek]
                      ,@AfterDateText AS [DayOfWeekName]
                      ,@AfterDateText AS [DayOfWeekNameShort]
                      ,@AfterDateText AS [WeekdayName]
                      ,@AfterDateText AS [WeekdayNameShort]
                      ,9999 AS [WeekYear]
                      ,9999 AS [WeekOfYear]
                      ,@AfterDateText AS [WeekOfYearName]
                      ,@AfterDateText AS [WeekOfYearNameShort]
                      ,9999 AS [MonthOfYear]
                      ,@AfterDateText AS [MonthOfYearName]
                      ,@AfterDateText AS [MonthOfYearNameShort]
                      ,9999 AS [MonthOfQuarter]
                      ,@AfterDateText AS [MonthOfQuarterName]
                      ,@AfterDateText AS [MonthOfQuarterNameShort]
                      ,9999 AS [QuarterOfYear]
                      ,@AfterDateText AS [QuarterOfYearName]
                      ,@AfterDateText AS [QuarterOfYearNameShort]
                      ,@AfterDateText AS [Holiday]
                      ,@AfterDateText AS [HolidayName]
                      ,@AfterDateText AS [WorkingDay]
                      ,0 AS [WorkingDayOfMonth]
                      ,DATEFROMPARTS(YEAR(DATEADD(YEAR, 20, @ToDate)), 12, 31) AS [FiscalYear]
                      ,@AfterDateText AS [FiscalYearName]
                      ,@AfterDateText AS [FiscalYearNameShort]
                      ,9999 AS [MonthOfFiscalYear]
                      ,@AfterDateText AS [MonthNameOfFiscalYear]
                      ,9999 AS [QuarterOfFiscalYear]
                      ,@AfterDateText AS [QuarterOfFiscalYearName]
                      ,@AfterDateText AS [QuarterOfFiscalYearNameShort]
                      ,DATEFROMPARTS(YEAR(DATEADD(YEAR, 20, @ToDate)), 12, 31) AS [FiscalQuarterDate]
            ) AS [s]
            ON [s].[DW_SK_Date] = [d].[DW_SK_Date]
            WHEN NOT MATCHED BY TARGET THEN
                INSERT
                (
                    [DW_SK_Date]
                   ,[Date]
                   ,[DayName]
                   ,[DayNameShort]
                   ,[Year]
                   ,[YearName]
                   ,[YearNameShort]
                   ,[YearNumber]
                   ,[Quarter]
                   ,[QuarterName]
                   ,[QuarterNameShort]
                   ,[Month]
                   ,[MonthEnd]
                   ,[MonthName]
                   ,[MonthNameShort]
                   ,[Week]
                   ,[WeekName]
                   ,[WeekNameShort]
                   ,[DayOfYear]
                   ,[DayOfYearName]
                   ,[DayOfYearNameShort]
                   ,[DayOfQuarter]
                   ,[DayOfQuarterName]
                   ,[DayOfQuarterNameShort]
                   ,[DayOfMonth]
                   ,[DayOfMonthName]
                   ,[DayOfMonthNameShort]
                   ,[DayOfWeek]
                   ,[DayOfWeekName]
                   ,[DayOfWeekNameShort]
                   ,[WeekdayName]
                   ,[WeekdayNameShort]
                   ,[WeekYear]
                   ,[WeekOfYear]
                   ,[WeekOfYearName]
                   ,[WeekOfYearNameShort]
                   ,[MonthOfYear]
                   ,[MonthOfYearName]
                   ,[MonthOfYearNameShort]
                   ,[MonthOfQuarter]
                   ,[MonthOfQuarterName]
                   ,[MonthOfQuarterNameShort]
                   ,[QuarterOfYear]
                   ,[QuarterOfYearName]
                   ,[QuarterOfYearNameShort]
                   ,[Holiday]
                   ,[HolidayName]
                   ,[WorkingDay]
                   ,[WorkingDayOfMonth]
                   ,[FiscalYear]
                   ,[FiscalYearName]
                   ,[FiscalYearNameShort]
                   ,[MonthOfFiscalYear]
                   ,[MonthNameOfFiscalYear]
                   ,[QuarterOfFiscalYear]
                   ,[QuarterOfFiscalYearName]
                   ,[QuarterOfFiscalYearNameShort]
                   ,[FiscalQuarterDate]
                )
                VALUES
                (
                    [s].[DW_SK_Date], [s].[Date], [s].[DayName], [s].[DayNameShort], [s].[Year], [s].[YearName], [s].[YearNameShort], [s].[YearNumber], [s].[Quarter], [s].[QuarterName], [s].[QuarterNameShort], [s].[Month], [s].[MonthEnd]
                   ,[s].[MonthName], [s].[MonthNameShort], [s].[Week], [s].[WeekName], [s].[WeekNameShort], [s].[DayOfYear], [s].[DayOfYearName], [s].[DayOfYearNameShort], [s].[DayOfQuarter], [s].[DayOfQuarterName]
                   ,[s].[DayOfQuarterNameShort], [s].[DayOfMonth], [s].[DayOfMonthName], [s].[DayOfMonthNameShort], [s].[DayOfWeek], [s].[DayOfWeekName], [s].[DayOfWeekNameShort], [s].[WeekdayName], [s].[WeekdayNameShort], [s].[WeekYear]
                   ,[s].[WeekOfYear], [s].[WeekOfYearName], [s].[WeekOfYearNameShort], [s].[MonthOfYear], [s].[MonthOfYearName], [s].[MonthOfYearNameShort], [s].[MonthOfQuarter], [s].[MonthOfQuarterName], [s].[MonthOfQuarterNameShort]
                   ,[s].[QuarterOfYear], [s].[QuarterOfYearName], [s].[QuarterOfYearNameShort], [s].[Holiday], [s].[HolidayName], [s].[WorkingDay], [s].[WorkingDayOfMonth], [s].[FiscalYear], [s].[FiscalYearName], [s].[FiscalYearNameShort]
                   ,[s].[MonthOfFiscalYear], [s].[MonthNameOfFiscalYear], [s].[QuarterOfFiscalYear], [s].[QuarterOfFiscalYearName], [s].[QuarterOfFiscalYearNameShort], [s].[FiscalQuarterDate]
                )
            WHEN MATCHED THEN
                UPDATE SET [d].[Date] = [s].[Date]
                          ,[d].[DayName] = [s].[DayName]
                          ,[d].[DayNameShort] = [s].[DayNameShort]
                          ,[d].[Year] = [s].[Year]
                          ,[d].[YearName] = [s].[YearName]
                          ,[d].[YearNameShort] = [s].[YearNameShort]
                          ,[d].[YearNumber] = [s].[YearNumber]
                          ,[d].[Quarter] = [s].[Quarter]
                          ,[d].[QuarterName] = [s].[QuarterName]
                          ,[d].[QuarterNameShort] = [s].[QuarterNameShort]
                          ,[d].[Month] = [s].[Month]
                          ,[d].[MonthEnd] = [s].[MonthEnd]
                          ,[d].[MonthName] = [s].[MonthName]
                          ,[d].[MonthNameShort] = [s].[MonthNameShort]
                          ,[d].[Week] = [s].[Week]
                          ,[d].[WeekName] = [s].[WeekName]
                          ,[d].[WeekNameShort] = [s].[WeekNameShort]
                          ,[d].[DayOfYear] = [s].[DayOfYear]
                          ,[d].[DayOfYearName] = [s].[DayOfYearName]
                          ,[d].[DayOfYearNameShort] = [s].[DayOfYearNameShort]
                          ,[d].[DayOfQuarter] = [s].[DayOfQuarter]
                          ,[d].[DayOfQuarterName] = [s].[DayOfQuarterName]
                          ,[d].[DayOfQuarterNameShort] = [s].[DayOfQuarterNameShort]
                          ,[d].[DayOfMonth] = [s].[DayOfMonth]
                          ,[d].[DayOfMonthName] = [s].[DayOfMonthName]
                          ,[d].[DayOfMonthNameShort] = [s].[DayOfMonthNameShort]
                          ,[d].[DayOfWeek] = [s].[DayOfWeek]
                          ,[d].[DayOfWeekName] = [s].[DayOfWeekName]
                          ,[d].[DayOfWeekNameShort] = [s].[DayOfWeekNameShort]
                          ,[d].[WeekdayName] = [s].[WeekdayName]
                          ,[d].[WeekdayNameShort] = [s].[WeekdayNameShort]
                          ,[d].[WeekYear] = [s].[WeekYear]
                          ,[d].[WeekOfYear] = [s].[WeekOfYear]
                          ,[d].[WeekOfYearName] = [s].[WeekOfYearName]
                          ,[d].[WeekOfYearNameShort] = [s].[WeekOfYearNameShort]
                          ,[d].[MonthOfYear] = [s].[MonthOfYear]
                          ,[d].[MonthOfYearName] = [s].[MonthOfYearName]
                          ,[d].[MonthOfYearNameShort] = [s].[MonthOfYearNameShort]
                          ,[d].[MonthOfQuarter] = [s].[MonthOfQuarter]
                          ,[d].[MonthOfQuarterName] = [s].[MonthOfQuarterName]
                          ,[d].[MonthOfQuarterNameShort] = [s].[MonthOfQuarterNameShort]
                          ,[d].[QuarterOfYear] = [s].[QuarterOfYear]
                          ,[d].[QuarterOfYearName] = [s].[QuarterOfYearName]
                          ,[d].[QuarterOfYearNameShort] = [s].[QuarterOfYearNameShort]
                          ,[d].[Holiday] = [s].[Holiday]
                          ,[d].[HolidayName] = [s].[HolidayName]
                          ,[d].[WorkingDay] = [s].[WorkingDay]
                          ,[d].[WorkingDayOfMonth] = [s].[WorkingDayOfMonth]
                          ,[d].[FiscalYear] = [s].[FiscalYear]
                          ,[d].[FiscalYearName] = [s].[FiscalYearName]
                          ,[d].[FiscalYearNameShort] = [s].[FiscalYearNameShort]
                          ,[d].[MonthOfFiscalYear] = [s].[MonthOfFiscalYear]
                          ,[d].[MonthNameOfFiscalYear] = [s].[MonthNameOfFiscalYear]
                          ,[d].[QuarterOfFiscalYear] = [s].[QuarterOfFiscalYear]
                          ,[d].[QuarterOfFiscalYearName] = [s].[QuarterOfFiscalYearName]
                          ,[d].[QuarterOfFiscalYearNameShort] = [s].[QuarterOfFiscalYearNameShort]
                          ,[d].[FiscalQuarterDate] = [s].[FiscalQuarterDate];

            ALTER INDEX [PK_Date] ON [dim].[Date] REBUILD;

        END;

        -- Commit only if the transaction was started in this procedure
        IF @TranCounter = 0 COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH

        -- Only rollback if transaction was started in this procedure
        IF @TranCounter = 0 ROLLBACK TRANSACTION;
        -- It's not our transaction but it's still OK
        ELSE IF XACT_STATE() = 1 ROLLBACK TRANSACTION @SavePoint;
        -- All hope is lost - rollback!
        ELSE IF XACT_STATE() = -1 ROLLBACK TRANSACTION;

        THROW;
        RETURN 1;

    END CATCH;
END;

GO

