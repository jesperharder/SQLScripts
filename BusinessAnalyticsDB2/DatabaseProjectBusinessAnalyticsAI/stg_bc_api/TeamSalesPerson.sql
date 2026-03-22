CREATE TABLE [stg_bc_api].[TeamSalesPerson] (
    [CompanyId]           INT              NOT NULL,
    [teamCode]            NVARCHAR (20)    NOT NULL,
    [salespersonCode]     NVARCHAR (20)    NOT NULL,
    [systemId]            UNIQUEIDENTIFIER NULL,
    [fromDate]            DATE             NULL,
    [toDate]              DATE             NULL,
    [role]                NVARCHAR (50)    NULL,
    [roleInt]             INT              NULL,
    [systemCreatedAt]     DATETIME2 (7)    NULL,
    [systemCreatedBy]     NVARCHAR (250)   NULL,
    [systemModifiedAt]    DATETIME2 (7)    NULL,
    [systemModifiedBy]    NVARCHAR (250)   NULL,
    [PipelineName]        NVARCHAR (200)   NULL,
    [PipelineRunId]       NVARCHAR (100)   NULL,
    [PipelineTriggerTime] DATETIME2 (7)    NULL,
    CONSTRAINT [PK_TeamSalesPerson] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [teamCode] ASC, [salespersonCode] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_TeamSalesPerson_Salesperson]
    ON [stg_bc_api].[TeamSalesPerson]([CompanyId] ASC, [salespersonCode] ASC)
    INCLUDE([teamCode], [systemModifiedAt]);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_TeamSalesPerson_Upsert]
    ON [stg_bc_api].[TeamSalesPerson]([CompanyId] ASC, [teamCode] ASC, [salespersonCode] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_TeamSalesPerson_ModifiedAt]
    ON [stg_bc_api].[TeamSalesPerson]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([teamCode], [salespersonCode]);


GO

CREATE NONCLUSTERED INDEX [IX_TeamSalesPerson_Team]
    ON [stg_bc_api].[TeamSalesPerson]([CompanyId] ASC, [teamCode] ASC)
    INCLUDE([salespersonCode], [systemModifiedAt]);


GO

