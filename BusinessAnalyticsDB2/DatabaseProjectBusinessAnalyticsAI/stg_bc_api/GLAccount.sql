CREATE TABLE [stg_bc_api].[GLAccount] (
    [CompanyId]            INT                NOT NULL,
    [no]                   NVARCHAR (20)      NOT NULL,
    [name]                 NVARCHAR (100)     NULL,
    [blocked]              BIT                NULL,
    [directPosting]        BIT                NULL,
    [accountType]          NVARCHAR (50)      NULL,
    [accountTypeInt]       INT                NULL,
    [incomeBalance]        NVARCHAR (50)      NULL,
    [incomeBalanceInt]     INT                NULL,
    [accountCategory]      NVARCHAR (50)      NULL,
    [accountCategoryInt]   INT                NULL,
    [totaling]             NVARCHAR (MAX)     NULL,
    [indentation]          INT                NULL,
    [lastModifiedDateTime] DATETIMEOFFSET (7) NULL,
    [systemCreatedAt]      DATETIMEOFFSET (7) NULL,
    [systemCreatedBy]      UNIQUEIDENTIFIER   NULL,
    [systemId]             UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]     DATETIMEOFFSET (7) NULL,
    [systemModifiedBy]     UNIQUEIDENTIFIER   NULL,
    [PipelineName]         NVARCHAR (200)     NULL,
    [PipelineRunId]        NVARCHAR (100)     NULL,
    [PipelineTriggerTime]  DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_GLAccount] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [no] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_GLAccount_Company_LastModified]
    ON [stg_bc_api].[GLAccount]([CompanyId] ASC, [lastModifiedDateTime] ASC);


GO

