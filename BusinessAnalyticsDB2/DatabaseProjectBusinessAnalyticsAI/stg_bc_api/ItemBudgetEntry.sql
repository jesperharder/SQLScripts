CREATE TABLE [stg_bc_api].[ItemBudgetEntry] (
    [CompanyId]            INT                NOT NULL,
    [entryNo]              INT                NOT NULL,
    [systemId]             UNIQUEIDENTIFIER   NULL,
    [analysisArea]         NVARCHAR (50)      NULL,
    [analysisAreaInt]      INT                NULL,
    [budgetName]           NVARCHAR (50)      NULL,
    [date]                 DATE               NULL,
    [itemNo]               NVARCHAR (20)      NULL,
    [sourceType]           NVARCHAR (50)      NULL,
    [sourceTypeInt]        INT                NULL,
    [sourceNo]             NVARCHAR (20)      NULL,
    [description]          NVARCHAR (100)     NULL,
    [quantity]             DECIMAL (18, 5)    NULL,
    [costAmount]           DECIMAL (18, 2)    NULL,
    [salesAmount]          DECIMAL (18, 2)    NULL,
    [userId]               NVARCHAR (50)      NULL,
    [locationCode]         NVARCHAR (10)      NULL,
    [globalDimension1Code] NVARCHAR (20)      NULL,
    [globalDimension2Code] NVARCHAR (20)      NULL,
    [budgetDimension1Code] NVARCHAR (20)      NULL,
    [budgetDimension2Code] NVARCHAR (20)      NULL,
    [budgetDimension3Code] NVARCHAR (20)      NULL,
    [dimensionSetId]       INT                NULL,
    [globalDimension1Id]   INT                NULL,
    [globalDimension2Id]   INT                NULL,
    [budgetDimension1Id]   INT                NULL,
    [budgetDimension2Id]   INT                NULL,
    [budgetDimension3Id]   INT                NULL,
    [itemDescription]      NVARCHAR (100)     NULL,
    [locationName]         NVARCHAR (100)     NULL,
    [sourceName]           NVARCHAR (100)     NULL,
    [globalDimension1Name] NVARCHAR (100)     NULL,
    [globalDimension2Name] NVARCHAR (100)     NULL,
    [budgetDimension1Name] NVARCHAR (100)     NULL,
    [budgetDimension2Name] NVARCHAR (100)     NULL,
    [budgetDimension3Name] NVARCHAR (100)     NULL,
    [systemCreatedAt]      DATETIMEOFFSET (7) NULL,
    [systemCreatedBy]      UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]     DATETIMEOFFSET (7) NULL,
    [systemModifiedBy]     UNIQUEIDENTIFIER   NULL,
    [PipelineName]         NVARCHAR (200)     NULL,
    [PipelineRunId]        NVARCHAR (100)     NULL,
    [PipelineTriggerTime]  DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_ItemBudgetEntry] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [entryNo] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_ItemBudgetEntry_Company_SystemModifiedAt]
    ON [stg_bc_api].[ItemBudgetEntry]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([entryNo]);


GO

