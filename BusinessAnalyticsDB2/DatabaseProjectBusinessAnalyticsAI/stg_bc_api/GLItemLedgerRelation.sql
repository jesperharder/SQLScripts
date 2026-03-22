CREATE TABLE [stg_bc_api].[GLItemLedgerRelation] (
    [CompanyId]           INT                NOT NULL,
    [glEntryNo]           INT                NOT NULL,
    [valueEntryNo]        INT                NOT NULL,
    [glRegisterNo]        INT                NULL,
    [systemId]            UNIQUEIDENTIFIER   NULL,
    [systemCreatedAt]     DATETIMEOFFSET (7) NULL,
    [systemCreatedBy]     UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]    DATETIMEOFFSET (7) NULL,
    [systemModifiedBy]    UNIQUEIDENTIFIER   NULL,
    [PipelineName]        NVARCHAR (200)     NULL,
    [PipelineRunId]       NVARCHAR (100)     NULL,
    [PipelineTriggerTime] DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_GLItemLedgerRelation] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [glEntryNo] ASC, [valueEntryNo] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_GLItemLedgerRelation_Company_SystemModified]
    ON [stg_bc_api].[GLItemLedgerRelation]([CompanyId] ASC, [systemModifiedAt] ASC);


GO

