CREATE TABLE [etl].[YearCodeLookupMaster] (
    [Code]         NCHAR (10) NOT NULL,
    [IntervalFrom] DATETIME   NOT NULL,
    [IntervalTo]   DATETIME   NOT NULL,
    CONSTRAINT [PK_YearCodes_1] PRIMARY KEY CLUSTERED ([Code] ASC)
);


GO

