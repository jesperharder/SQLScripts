CREATE TABLE [stg_bc_api].[GenBusinessPostingGroup] (
    [CompanyId]             INT                NOT NULL,
    [code]                  NVARCHAR (20)      NOT NULL,
    [description]           NVARCHAR (100)     NULL,
    [defVATBusPostingGroup] NVARCHAR (20)      NULL,
    [systemId]              UNIQUEIDENTIFIER   NULL,
    [systemCreatedAt]       DATETIMEOFFSET (7) NULL,
    [systemCreatedBy]       UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]      DATETIMEOFFSET (7) NULL,
    [systemModifiedBy]      UNIQUEIDENTIFIER   NULL,
    [PipelineName]          NVARCHAR (200)     NULL,
    [PipelineRunId]         NVARCHAR (100)     NULL,
    [PipelineTriggerTime]   DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_GenBusinessPostingGroup] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [code] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_GenBusinessPostingGroup_Company_SystemModified]
    ON [stg_bc_api].[GenBusinessPostingGroup]([CompanyId] ASC, [systemModifiedAt] ASC);


GO

