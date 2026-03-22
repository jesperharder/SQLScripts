CREATE TABLE [stg_bc].[ShipmentMethod] (
    [timestamp]               VARBINARY (8)      NOT NULL,
    [Code]                    NVARCHAR (20)      NOT NULL,
    [Description]             NVARCHAR (100)     NULL,
    [Last Modified Date Time] DATETIME           NOT NULL,
    [Id]                      NVARCHAR (36)      NOT NULL,
    [$systemId]               NVARCHAR (36)      NULL,
    [$systemCreatedAt]        DATETIME           NULL,
    [$systemCreatedBy]        NVARCHAR (36)      NULL,
    [$systemModifiedAt]       DATETIME           NULL,
    [$systemModifiedBy]       NVARCHAR (36)      NULL,
    [PipelineName]            NVARCHAR (128)     CONSTRAINT [DF_ShipmentMethod_PipelineName] DEFAULT ('Default') NOT NULL,
    [PipelineRunId]           NVARCHAR (36)      CONSTRAINT [DF_ShipmentMethod_PipelineRunId] DEFAULT ('00000000-0000-0000-0000-000000000000') NOT NULL,
    [PipelineTriggerTime]     DATETIMEOFFSET (7) CONSTRAINT [DF_ShipmentMethod_PipelineTriggerTime] DEFAULT (sysdatetimeoffset()) NOT NULL,
    [CompanyID]               INT                NOT NULL,
    CONSTRAINT [PK_stg_bc_ShipmentMethod] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [Code] ASC)
);


GO

CREATE NONCLUSTERED INDEX [ix_stg_bc_ShipmentMethod_timestamp]
    ON [stg_bc].[ShipmentMethod]([CompanyID] ASC, [timestamp] ASC);


GO

