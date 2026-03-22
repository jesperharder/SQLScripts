CREATE TABLE [stg_bc].[GLBudgetEntry] (
    [timestamp]               VARBINARY (8)      NOT NULL,
    [Entry No_]               INT                NOT NULL,
    [Budget Name]             NVARCHAR (10)      NOT NULL,
    [G_L Account No_]         NVARCHAR (20)      NOT NULL,
    [Date]                    DATETIME           NOT NULL,
    [Global Dimension 1 Code] NVARCHAR (20)      NOT NULL,
    [Global Dimension 2 Code] NVARCHAR (20)      NOT NULL,
    [Amount]                  DECIMAL (38, 20)   NOT NULL,
    [Description]             NVARCHAR (100)     NOT NULL,
    [Business Unit Code]      NVARCHAR (20)      NOT NULL,
    [User ID]                 NVARCHAR (50)      NOT NULL,
    [Budget Dimension 1 Code] NVARCHAR (20)      NOT NULL,
    [Budget Dimension 2 Code] NVARCHAR (20)      NOT NULL,
    [Budget Dimension 3 Code] NVARCHAR (20)      NOT NULL,
    [Budget Dimension 4 Code] NVARCHAR (20)      NOT NULL,
    [Last Date Modified]      DATETIME           NOT NULL,
    [Dimension Set ID]        INT                NOT NULL,
    [$systemId]               NVARCHAR (36)      NOT NULL,
    [$systemCreatedAt]        DATETIME           NOT NULL,
    [$systemCreatedBy]        NVARCHAR (36)      NOT NULL,
    [PipelineName]            NVARCHAR (200)     CONSTRAINT [DF_GLBudgetEntry_PipelineName] DEFAULT ('Default') NOT NULL,
    [PipelineRunId]           NVARCHAR (36)      CONSTRAINT [DF_GLBudgetEntry_PipelineRunId] DEFAULT ('00000000-0000-0000-0000-000000000000') NOT NULL,
    [PipelineTriggerTime]     DATETIMEOFFSET (0) CONSTRAINT [DF_GLBudgetEntry_PipelineTriggerTime] DEFAULT (sysdatetimeoffset()) NOT NULL,
    [CompanyID]               INT                NOT NULL,
    CONSTRAINT [PK_stg_bc_GLBudgetEntry] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [Entry No_] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

CREATE NONCLUSTERED INDEX [ix_stg_bc_GLBudgetEntry_timestamp]
    ON [stg_bc].[GLBudgetEntry]([CompanyID] ASC, [timestamp] ASC);


GO

