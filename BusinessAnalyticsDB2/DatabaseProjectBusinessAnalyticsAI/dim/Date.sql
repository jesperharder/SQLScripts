CREATE TABLE [dim].[Date] (
    [DateKey]          INT           NOT NULL,
    [Date]             DATE          NOT NULL,
    [Year]             NVARCHAR (4)  NULL,
    [Monthnumber]      NCHAR (2)     NULL,
    [YearMonthnumber]  NVARCHAR (7)  NULL,
    [YearMonthShort]   NVARCHAR (8)  NULL,
    [MonthNameShort]   NVARCHAR (8)  NULL,
    [MonthNameLong]    NVARCHAR (15) NULL,
    [DayOfWeekNumber]  NCHAR (1)     NULL,
    [DayOfWeek]        NVARCHAR (10) NULL,
    [DayOfWeekShort]   NVARCHAR (3)  NULL,
    [Week]             NCHAR (2)     NULL,
    [LastDateOfWeekUS] DATE          NULL,
    [Quarter]          NCHAR (2)     NULL,
    [YearQuarter]      NVARCHAR (7)  NULL,
    [YearWeek]         NVARCHAR (8)  NULL,
    [WeekNo]           NCHAR (2)     NULL,
    [YYMM]             NVARCHAR (6)  NULL,
    [BudgetMD]         DATE          NULL,
    [EO-MONTH]         DATE          NULL,
    [DurationYear]     AS            (datepart(year,getdate())-datepart(year,[Date])),
    [DurationDays]     AS            (datediff(day,[Date],getdate())),
    [DurationWeek]     AS            (((datepart(year,getdate())-datepart(year,[Date]))*(52)+datepart(iso_week,getdate()))-datepart(iso_week,[Date])),
    [DurationMonth]    AS            (((datepart(year,getdate())-datepart(year,[Date]))*(12)+datepart(month,getdate()))-datepart(month,[Date])),
    [DurationQuarter]  AS            (((datepart(year,getdate())-datepart(year,[Date]))*(4)+round(datepart(month,getdate())/(3),(0)))-round(datepart(month,[Date])/(3),(0))),
    [CurrentDay]       AS            (case when dateadd(day,datediff(day,(0),getdate()),(0))=[Date] then 'Yes' else 'No' end),
    [Yesterday]        AS            (case when dateadd(day,datediff(day,(0),getdate()),(-1))=[Date] then 'Yes' else 'No' end),
    [CurrentYear]      AS            (case when dateadd(year,datediff(year,(0),getdate()),(0))=dateadd(year,datediff(year,(0),[Date]),(0)) then 'Yes' else 'No' end),
    [CurrentQuarter]   AS            (case when dateadd(quarter,datediff(quarter,(0),getdate()),(0))=dateadd(quarter,datediff(quarter,(0),[Date]),(0)) then 'Yes' else 'No' end),
    [CurrentMonth]     AS            (case when dateadd(month,datediff(month,(0),getdate()),(0))=dateadd(month,datediff(month,(0),[Date]),(0)) then 'Yes' else 'No' end),
    [CurrentWeek]      AS            (case when dateadd(week,datediff(week,(0),getdate()),(0))=dateadd(week,datediff(week,(0),[Date]),(0)) then 'Yes' else 'No' end),
    [FutureDate]       AS            (case when dateadd(day,datediff(day,(0),getdate()),(0))<[Date] then 'Yes' else 'No' end),
    CONSTRAINT [PK_Date] PRIMARY KEY CLUSTERED ([DateKey] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

CREATE UNIQUE NONCLUSTERED INDEX [NIX_dim_Date_DateKey_WithIncluded]
    ON [dim].[Date]([DateKey] ASC)
    INCLUDE([Date]) WITH (DATA_COMPRESSION = ROW);


GO

CREATE NONCLUSTERED INDEX [IX_dim_Date_Date]
    ON [dim].[Date]([Date] ASC) WITH (DATA_COMPRESSION = ROW);


GO

CREATE NONCLUSTERED INDEX [IX_dim_Date_EOMonth]
    ON [dim].[Date]([EO-MONTH] ASC) WITH (DATA_COMPRESSION = ROW);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Dimension', @level0type = N'SCHEMA', @level0name = N'dim', @level1type = N'TABLE', @level1name = N'Date';


GO

