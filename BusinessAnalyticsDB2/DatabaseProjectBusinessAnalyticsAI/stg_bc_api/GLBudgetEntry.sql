CREATE TABLE [stg_bc_api].[GLBudgetEntry] (
    [CompanyId]            INT                NOT NULL,
    [budgetName]           NVARCHAR (20)      NOT NULL,
    [glAccountNo]          NVARCHAR (20)      NOT NULL,
    [date]                 DATE               NOT NULL,
    [businessUnitCode]     NVARCHAR (10)      NOT NULL,
    [globalDimension1Code] NVARCHAR (20)      NOT NULL,
    [globalDimension2Code] NVARCHAR (20)      NOT NULL,
    [amount]               DECIMAL (38, 20)   NULL,
    [dimensionSetId]       INT                NULL,
    [systemId]             UNIQUEIDENTIFIER   NULL,
    [systemCreatedAt]      DATETIMEOFFSET (7) NULL,
    [systemCreatedBy]      UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]     DATETIMEOFFSET (7) NULL,
    [systemModifiedBy]     UNIQUEIDENTIFIER   NULL,
    [PipelineName]         NVARCHAR (200)     NULL,
    [PipelineRunId]        NVARCHAR (100)     NULL,
    [PipelineTriggerTime]  DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_GLBudgetEntry] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [budgetName] ASC, [glAccountNo] ASC, [date] ASC, [businessUnitCode] ASC, [globalDimension1Code] ASC, [globalDimension2Code] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_GLBudgetEntry_Company_SystemModified]
    ON [stg_bc_api].[GLBudgetEntry]([CompanyId] ASC, [systemModifiedAt] ASC);


GO

