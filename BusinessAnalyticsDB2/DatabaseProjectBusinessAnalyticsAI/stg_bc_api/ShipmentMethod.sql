CREATE TABLE [stg_bc_api].[ShipmentMethod] (
    [CompanyId]           INT              NOT NULL,
    [code]                NVARCHAR (10)    NOT NULL,
    [description]         NVARCHAR (100)   NULL,
    [systemId]            UNIQUEIDENTIFIER NULL,
    [systemCreatedAt]     DATETIME2 (7)    NULL,
    [systemCreatedBy]     NVARCHAR (250)   NULL,
    [systemModifiedAt]    DATETIME2 (7)    NULL,
    [systemModifiedBy]    NVARCHAR (250)   NULL,
    [PipelineName]        NVARCHAR (200)   NULL,
    [PipelineRunId]       NVARCHAR (100)   NULL,
    [PipelineTriggerTime] DATETIME2 (7)    NULL,
    CONSTRAINT [PK_ShipmentMethod] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [code] ASC)
);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_ShipmentMethod_Upsert]
    ON [stg_bc_api].[ShipmentMethod]([CompanyId] ASC, [code] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_ShipmentMethod_ModifiedAt]
    ON [stg_bc_api].[ShipmentMethod]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([code], [description]);


GO

CREATE NONCLUSTERED INDEX [IX_ShipmentMethod_Description]
    ON [stg_bc_api].[ShipmentMethod]([CompanyId] ASC, [description] ASC)
    INCLUDE([code], [systemModifiedAt]);


GO

