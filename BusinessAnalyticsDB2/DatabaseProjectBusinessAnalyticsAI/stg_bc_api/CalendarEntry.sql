CREATE TABLE [stg_bc_api].[CalendarEntry] (
    [CompanyId]           INT                NOT NULL,
    [id]                  UNIQUEIDENTIFIER   NOT NULL,
    [capacityType]        NVARCHAR (50)      NULL,
    [capacityTypeInt]     INT                NULL,
    [number]              NVARCHAR (20)      NULL,
    [date]                DATE               NULL,
    [workShiftCode]       NVARCHAR (20)      NULL,
    [startingTime]        TIME (0)           NULL,
    [endingTime]          TIME (0)           NULL,
    [workCenterNo]        NVARCHAR (20)      NULL,
    [workCenterGroupCode] NVARCHAR (20)      NULL,
    [capacityTotal]       DECIMAL (18, 6)    NULL,
    [capacityEffective]   DECIMAL (18, 6)    NULL,
    [efficiency]          DECIMAL (18, 6)    NULL,
    [capacity]            DECIMAL (18, 6)    NULL,
    [absenceEfficiency]   DECIMAL (18, 6)    NULL,
    [absenceCapacity]     DECIMAL (18, 6)    NULL,
    [startingDateTime]    DATETIME2 (7)      NULL,
    [endingDateTime]      DATETIME2 (7)      NULL,
    [systemCreatedAt]     DATETIME2 (7)      NULL,
    [systemModifiedAt]    DATETIME2 (7)      NULL,
    [PipelineName]        NVARCHAR (200)     NULL,
    [PipelineRunId]       UNIQUEIDENTIFIER   NULL,
    [PipelineTriggerTime] DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_CalendarEntry] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [id] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_CalendarEntry_Company_Modified]
    ON [stg_bc_api].[CalendarEntry]([CompanyId] ASC, [systemModifiedAt] ASC);


GO

