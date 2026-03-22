CREATE TABLE [stg_bc_api].[SalespersonPurchaser] (
    [CompanyId]           INT              NOT NULL,
    [code]                NVARCHAR (20)    NOT NULL,
    [name]                NVARCHAR (100)   NULL,
    [email]               NVARCHAR (80)    NULL,
    [phoneNo]             NVARCHAR (30)    NULL,
    [commissionPct]       DECIMAL (38, 20) NULL,
    [systemId]            UNIQUEIDENTIFIER NULL,
    [systemCreatedAt]     DATETIME2 (7)    NULL,
    [systemCreatedBy]     NVARCHAR (250)   NULL,
    [systemModifiedAt]    DATETIME2 (7)    NULL,
    [systemModifiedBy]    NVARCHAR (250)   NULL,
    [PipelineName]        NVARCHAR (200)   NULL,
    [PipelineRunId]       NVARCHAR (100)   NULL,
    [PipelineTriggerTime] DATETIME2 (7)    NULL,
    CONSTRAINT [PK_SalespersonPurchaser] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [code] ASC)
);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_SalespersonPurchaser_Upsert]
    ON [stg_bc_api].[SalespersonPurchaser]([CompanyId] ASC, [code] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_SalespersonPurchaser_Name]
    ON [stg_bc_api].[SalespersonPurchaser]([CompanyId] ASC, [name] ASC)
    INCLUDE([code], [email], [phoneNo], [commissionPct]);


GO

CREATE NONCLUSTERED INDEX [IX_SalespersonPurchaser_ModifiedAt]
    ON [stg_bc_api].[SalespersonPurchaser]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([code], [name], [email], [phoneNo], [commissionPct]);


GO

