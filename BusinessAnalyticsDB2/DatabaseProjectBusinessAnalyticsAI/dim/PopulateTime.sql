CREATE PROCEDURE [dim].[PopulateTime] @Language int /* 1 = UK, 2 = DK */
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE [dim].[Time];

    INSERT INTO [dim].[Time]
    (
        [DW_SK_Time]
       ,[TimeOfDay]
       ,[UTCOffsetMinutes]
       ,[UTCOffset]
       ,[MinuteKey]
       ,[MinuteName]
       ,[MinuteOfHourKey]
       ,[MinuteOfHourName]
       ,[QuarterKey]
       ,[QuarterName]
       ,[HalfHourKey]
       ,[HalfHourName]
       ,[HourKey]
       ,[HourName]
    )
    SELECT ([n].[Number] - 1) * 100 + [utc].[Number] AS [DW_SK_Time]
          ,CAST([minut].[TheMinute] AS time(0)) AS [TimeOfDay]
          ,[utc].[UTCOffsetMinutes]
          ,[utc].[UTCOffset]
          ,DATEPART(HOUR, [minut].[TheMinute]) * 100 + DATEPART(MINUTE, [minut].[TheMinute]) AS [MinuteKey]
          ,LEFT(CAST(CAST([minut].[TheMinute] AS time(0)) AS nvarchar(8)), 5) AS [MinuteName]
          ,DATEPART(MINUTE, [minut].[TheMinute]) AS [MinuteOfHourKey]
          ,FORMAT(DATEPART(MINUTE, [minut].[TheMinute]), '00') AS [MinuteOfHourName]
          ,DATEPART(HOUR, [minut].[TheMinute]) * 10 + CASE
                                                          WHEN DATEPART(MINUTE, [minut].[TheMinute]) < 15 THEN
                                                              1
                                                          WHEN DATEPART(MINUTE, [minut].[TheMinute]) >= 15
                                                          AND  DATEPART(MINUTE, [minut].[TheMinute]) < 30 THEN
                                                              2
                                                          WHEN DATEPART(MINUTE, [minut].[TheMinute]) >= 30
                                                          AND  DATEPART(MINUTE, [minut].[TheMinute]) < 45 THEN
                                                              3
                                                          WHEN DATEPART(MINUTE, [minut].[TheMinute]) >= 45
                                                          AND  DATEPART(MINUTE, [minut].[TheMinute]) < 60 THEN
                                                              4
                                                          ELSE
                                                              NULL
                                                      END AS [QuarterKey]
          ,N'' AS [QuarterName]
          ,DATEPART(HOUR, [minut].[TheMinute]) * 10 + CASE
                                                          WHEN DATEPART(MINUTE, [minut].[TheMinute]) < 30 THEN
                                                              1
                                                          WHEN DATEPART(MINUTE, [minut].[TheMinute]) >= 30
                                                          AND  DATEPART(MINUTE, [minut].[TheMinute]) < 60 THEN
                                                              2
                                                          ELSE
                                                              NULL
                                                      END AS [HalfHourKey]
          ,N'' AS [HalfHourName]
          ,DATEPART(HOUR, [minut].[TheMinute]) AS [HourKey]
          ,FORMAT(DATEPART(HOUR, [minut].[TheMinute]), '00') + N':00' AS [HourName]
    FROM [utl].[Numbers] AS [n]
    CROSS APPLY
    (SELECT DATEADD(mi, [n].[Number] - 1, '20000101 00:00:00') AS [TheMinute]) AS [minut]
    CROSS APPLY
    (
        SELECT [utcn].[Number]
              ,(-4 + [utcn].[Number]) * 60 AS [UTCOffsetMinutes]
              ,CASE
                   WHEN (-4 + [utcn].[Number]) * 60 < 0 THEN
                       N'-'
                   ELSE
                       '+'
               END + FORMAT(ABS(-4 + [utcn].[Number]), '00') + ':00' AS [UTCOffset]
        FROM [utl].[Numbers] AS [utcn]
        WHERE [utcn].[Number] <= 10
    ) AS [utc]
    WHERE [n].[Number] <= 1440;

    UPDATE [dim].[Time]
    SET [QuarterName] = CASE
                            WHEN [QuarterKey] % 10 = 1 THEN
                                FORMAT([HourKey], '00') + ':00 - ' + FORMAT([HourKey], '00') + ':14'
                            WHEN [QuarterKey] % 10 = 2 THEN
                                FORMAT([HourKey], '00') + ':15 - ' + FORMAT([HourKey], '00') + ':29'
                            WHEN [QuarterKey] % 10 = 3 THEN
                                FORMAT([HourKey], '00') + ':30 - ' + FORMAT([HourKey], '00') + ':44'
                            WHEN [QuarterKey] % 10 = 4 THEN
                                FORMAT([HourKey], '00') + ':45 - ' + FORMAT([HourKey], '00') + ':59'
                            ELSE
                                NULL
                        END
       ,[HalfHourName] = CASE
                             WHEN [HalfHourKey] % 10 = 1 THEN
                                 FORMAT([HourKey], '00') + ':00 - ' + FORMAT([HourKey], '00') + ':29'
                             WHEN [HalfHourKey] % 10 = 2 THEN
                                 FORMAT([HourKey], '00') + ':30 - ' + FORMAT([HourKey], '00') + ':59'
                             ELSE
                                 NULL
                         END;

    -- Insert unknown member
    IF @Language = 1
    BEGIN
        INSERT INTO [dim].[Time]
        (
            [DW_SK_Time]
           ,[TimeOfDay]
           ,[MinuteKey]
           ,[MinuteName]
           ,[MinuteOfHourKey]
           ,[MinuteOfHourName]
           ,[QuarterKey]
           ,[QuarterName]
           ,[HalfHourKey]
           ,[HalfHourName]
           ,[HourKey]
           ,[HourName]
        )
        SELECT -1
              ,'00:00:00'
              ,-1
              ,N'Unknown time of day'
              ,-1
              ,N'Unknown time of day'
              ,-1
              ,N'Unknown time of day'
              ,-1
              ,N'Unknown time of day'
              ,-1
              ,'Unknown hour';
    END;

    IF @Language = 2
    BEGIN
        INSERT INTO [dim].[Time]
        (
            [DW_SK_Time]
           ,[TimeOfDay]
           ,[MinuteKey]
           ,[MinuteName]
           ,[MinuteOfHourKey]
           ,[MinuteOfHourName]
           ,[QuarterKey]
           ,[QuarterName]
           ,[HalfHourKey]
           ,[HalfHourName]
           ,[HourKey]
           ,[HourName]
        )
        SELECT -1
              ,'00:00:00'
              ,-1
              ,N'Ukendt tidspunkt'
              ,-1
              ,N'Ukendt tidspunkt'
              ,-1
              ,N'Ukendt tidspunkt'
              ,-1
              ,N'Ukendt tidspunkt'
              ,-1
              ,'Ukendt time';
    END;

    ALTER INDEX [PK_Time] ON [dim].[Time] REBUILD;
END;

GO

