CREATE TABLE [etl].[Statement] (
    [ReportNo]        INT           NULL,
    [LineNo]          INT           NULL,
    [ReportSection]   VARCHAR (255) NULL,
    [ReportHeadingNo] INT           NULL,
    [ReportHeading]   VARCHAR (255) NULL,
    [Operator]        VARCHAR (50)  NULL,
    [Format]          VARCHAR (50)  NULL,
    [Calc1]           VARCHAR (50)  NULL,
    [Calc2]           VARCHAR (50)  NULL,
    [Report]          VARCHAR (50)  NULL,
    [Signage]         INT           NOT NULL,
    [LinkReport]      VARCHAR (50)  NULL,
    [LinkLineNo]      INT           NOT NULL,
    [LinkHeading]     VARCHAR (255) NULL
);


GO

