CREATE TABLE [stg_bc].[CalendarEntry] (
    [timestamp]              VARBINARY (8)      NOT NULL,
    [Capacity Type]          INT                NOT NULL,
    [No_]                    NVARCHAR (20)      NOT NULL,
    [Date]                   DATETIME           NOT NULL,
    [Starting Time]          DATETIME           NOT NULL,
    [Ending Time]            DATETIME           NOT NULL,
    [Work Shift Code]        NVARCHAR (10)      NOT NULL,
    [Work Center No_]        NVARCHAR (20)      NOT NULL,
    [Work Center Group Code] NVARCHAR (10)      NOT NULL,
    [Capacity (Total)]       DECIMAL (38, 20)   NOT NULL,
    [Capacity (Effective)]   DECIMAL (38, 20)   NOT NULL,
    [Efficiency]             DECIMAL (38, 20)   NOT NULL,
    [Capacity]               DECIMAL (38, 20)   NOT NULL,
    [Absence Efficiency]     DECIMAL (38, 20)   NOT NULL,
    [Absence Capacity]       DECIMAL (38, 20)   NOT NULL,
    [Starting Date-Time]     DATETIME           NOT NULL,
    [Ending Date-Time]       DATETIME           NOT NULL,
    [$systemId]              NVARCHAR (36)      NOT NULL,
    [$systemCreatedAt]       DATETIME           NOT NULL,
    [$systemCreatedBy]       NVARCHAR (36)      NOT NULL,
    [$systemModifiedAt]      DATETIME           NOT NULL,
    [$systemModifiedBy]      NVARCHAR (36)      NOT NULL,
    [PipelineName]           NVARCHAR (200)     CONSTRAINT [DF_CalendarEntry_PipelineName] DEFAULT ('Default') NOT NULL,
    [PipelineRunId]          NVARCHAR (36)      CONSTRAINT [DF_CalendarEntry_PipelineRunId] DEFAULT ('00000000-0000-0000-0000-000000000000') NOT NULL,
    [PipelineTriggerTime]    DATETIMEOFFSET (0) CONSTRAINT [DF_CalendarEntry_PipelineTriggerTime] DEFAULT (sysdatetimeoffset()) NOT NULL,
    [CompanyID]              INT                NOT NULL,
    CONSTRAINT [PK_stg_bc_CalendarEntry] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [Capacity Type] ASC, [No_] ASC, [Date] ASC, [Starting Time] ASC, [Ending Time] ASC, [Work Shift Code] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

