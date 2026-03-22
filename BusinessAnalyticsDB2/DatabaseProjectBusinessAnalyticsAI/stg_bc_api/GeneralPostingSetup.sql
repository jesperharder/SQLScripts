CREATE TABLE [stg_bc_api].[GeneralPostingSetup] (
    [CompanyId]              INT                NOT NULL,
    [genBusPostingGroup]     NVARCHAR (20)      NOT NULL,
    [genProdPostingGroup]    NVARCHAR (20)      NOT NULL,
    [salesAccount]           NVARCHAR (20)      NULL,
    [purchAccount]           NVARCHAR (20)      NULL,
    [cogsAccount]            NVARCHAR (20)      NULL,
    [salesLineDiscAccount]   NVARCHAR (20)      NULL,
    [purchLineDiscAccount]   NVARCHAR (20)      NULL,
    [salesInvDiscAccount]    NVARCHAR (20)      NULL,
    [purchInvDiscAccount]    NVARCHAR (20)      NULL,
    [salesCreditMemoAccount] NVARCHAR (20)      NULL,
    [purchCrMemoAccount]     NVARCHAR (20)      NULL,
    [inventoryAdjmtAccount]  NVARCHAR (20)      NULL,
    [systemId]               UNIQUEIDENTIFIER   NULL,
    [systemCreatedAt]        DATETIMEOFFSET (7) NULL,
    [systemCreatedBy]        UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]       DATETIMEOFFSET (7) NULL,
    [systemModifiedBy]       UNIQUEIDENTIFIER   NULL,
    [PipelineName]           NVARCHAR (200)     NULL,
    [PipelineRunId]          NVARCHAR (100)     NULL,
    [PipelineTriggerTime]    DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_GeneralPostingSetup] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [genBusPostingGroup] ASC, [genProdPostingGroup] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_GeneralPostingSetup_Company_SystemModified]
    ON [stg_bc_api].[GeneralPostingSetup]([CompanyId] ASC, [systemModifiedAt] ASC);


GO

