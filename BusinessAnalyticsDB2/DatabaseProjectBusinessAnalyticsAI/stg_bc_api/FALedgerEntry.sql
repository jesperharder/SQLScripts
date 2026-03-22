CREATE TABLE [stg_bc_api].[FALedgerEntry] (
    [CompanyId]            INT                NOT NULL,
    [entryNo]              INT                NOT NULL,
    [glEntryNo]            INT                NULL,
    [faNo]                 NVARCHAR (20)      NULL,
    [faPostingDate]        DATE               NULL,
    [postingDate]          DATE               NULL,
    [documentType]         NVARCHAR (50)      NULL,
    [documentNo]           NVARCHAR (20)      NULL,
    [description]          NVARCHAR (100)     NULL,
    [faPostingType]        NVARCHAR (50)      NULL,
    [faPostingTypeInt]     INT                NULL,
    [amount]               DECIMAL (38, 20)   NULL,
    [debitAmount]          DECIMAL (38, 20)   NULL,
    [creditAmount]         DECIMAL (38, 20)   NULL,
    [globalDimension1Code] NVARCHAR (20)      NULL,
    [globalDimension2Code] NVARCHAR (20)      NULL,
    [systemId]             UNIQUEIDENTIFIER   NULL,
    [systemCreatedAt]      DATETIMEOFFSET (7) NULL,
    [systemCreatedBy]      UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]     DATETIMEOFFSET (7) NULL,
    [systemModifiedBy]     UNIQUEIDENTIFIER   NULL,
    [PipelineName]         NVARCHAR (200)     NULL,
    [PipelineRunId]        NVARCHAR (100)     NULL,
    [PipelineTriggerTime]  DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_FALedgerEntry] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [entryNo] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_FALedgerEntry_Company_SystemModified]
    ON [stg_bc_api].[FALedgerEntry]([CompanyId] ASC, [systemModifiedAt] ASC);


GO

