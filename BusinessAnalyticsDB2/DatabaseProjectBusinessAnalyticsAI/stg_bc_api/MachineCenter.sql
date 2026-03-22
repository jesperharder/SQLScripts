CREATE TABLE [stg_bc_api].[MachineCenter] (
    [CompanyId]           INT                NOT NULL,
    [no]                  NVARCHAR (20)      NOT NULL,
    [description]         NVARCHAR (100)     NULL,
    [searchName]          NVARCHAR (100)     NULL,
    [workCenterNo]        NVARCHAR (20)      NULL,
    [blocked]             BIT                NULL,
    [blockedInt]          INT                NULL,
    [capacity]            DECIMAL (18, 5)    NULL,
    [setupTime]           DECIMAL (18, 5)    NULL,
    [waitTime]            DECIMAL (18, 5)    NULL,
    [moveTime]            DECIMAL (18, 5)    NULL,
    [queueTime]           DECIMAL (18, 5)    NULL,
    [unitCost]            DECIMAL (18, 5)    NULL,
    [overheadRate]        DECIMAL (18, 5)    NULL,
    [systemId]            UNIQUEIDENTIFIER   NOT NULL,
    [systemCreatedAt]     DATETIME2 (7)      NULL,
    [systemCreatedBy]     UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]    DATETIME2 (7)      NULL,
    [systemModifiedBy]    UNIQUEIDENTIFIER   NULL,
    [PipelineName]        NVARCHAR (200)     NULL,
    [PipelineRunId]       UNIQUEIDENTIFIER   NULL,
    [PipelineTriggerTime] DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_MachineCenter] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [no] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_MachineCenter_Key]
    ON [stg_bc_api].[MachineCenter]([CompanyId] ASC, [no] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_MachineCenter_SystemModifiedAt]
    ON [stg_bc_api].[MachineCenter]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([no]);


GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_MachineCenter_SystemId]
    ON [stg_bc_api].[MachineCenter]([systemId] ASC);


GO

