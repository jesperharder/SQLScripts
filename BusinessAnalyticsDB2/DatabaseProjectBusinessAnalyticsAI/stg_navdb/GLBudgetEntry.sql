CREATE TABLE [stg_navdb].[GLBudgetEntry] (
    [CompanyID]               TINYINT          NOT NULL,
    [timestamp]               VARBINARY (8)    NULL,
    [Entry No_]               INT              NOT NULL,
    [Budget Name]             VARCHAR (10)     NULL,
    [G_L Account No_]         VARCHAR (20)     NULL,
    [Date]                    DATETIME         NULL,
    [Global Dimension 1 Code] VARCHAR (20)     NULL,
    [Global Dimension 2 Code] VARCHAR (20)     NULL,
    [Amount]                  DECIMAL (38, 20) NULL,
    [Description]             VARCHAR (50)     NULL,
    [Business Unit Code]      VARCHAR (10)     NULL,
    [User ID]                 VARCHAR (20)     NULL,
    [Budget Dimension 1 Code] VARCHAR (20)     NULL,
    [Budget Dimension 2 Code] VARCHAR (20)     NULL,
    [Budget Dimension 3 Code] VARCHAR (20)     NULL,
    [Budget Dimension 4 Code] VARCHAR (20)     NULL,
    [PipelineName]            NVARCHAR (MAX)   NULL,
    [PipelineRunId]           NVARCHAR (MAX)   NULL,
    [PipelineTriggerTime]     NVARCHAR (MAX)   NULL,
    CONSTRAINT [PK_stg_navdb_GLBudgetEntry] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [Entry No_] ASC)
);


GO

CREATE NONCLUSTERED INDEX [ix_stg_navdb_GLBudgetEntry_timestamp]
    ON [stg_navdb].[GLBudgetEntry]([CompanyID] ASC, [timestamp] ASC);


GO

