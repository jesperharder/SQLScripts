CREATE TABLE [stg_bc].[ItemNotora] (
    [timestamp]                      VARBINARY (8)      NOT NULL,
    [No_]                            NVARCHAR (20)      NOT NULL,
    [ABCD Category]                  NVARCHAR (20)      NOT NULL,
    [Item Brand]                     NVARCHAR (50)      NOT NULL,
    [Product Line Code]              NVARCHAR (50)      NOT NULL,
    [Product Usage]                  NVARCHAR (50)      NOT NULL,
    [Prod_ Group Code]               NVARCHAR (50)      NOT NULL,
    [Item Size]                      NVARCHAR (50)      NOT NULL,
    [Item Size Unit]                 NVARCHAR (10)      NOT NULL,
    [Item Feature]                   NVARCHAR (50)      NOT NULL,
    [Packing Method]                 NVARCHAR (50)      NOT NULL,
    [Coating]                        NVARCHAR (50)      NOT NULL,
    [Quality]                        INT                NOT NULL,
    [With Lid]                       TINYINT            NOT NULL,
    [Weight Classification NOTO]     INT                NOT NULL,
    [Calculated Available NOTO]      DECIMAL (38, 20)   NOT NULL,
    [Calculated Available Ext_ NOTO] DECIMAL (38, 20)   NOT NULL,
    [Calculated Available Date NOTO] DATETIME           NOT NULL,
    [PipelineName]                   NVARCHAR (200)     CONSTRAINT [DF_ItemNotora_PipelineName] DEFAULT ('Default') NOT NULL,
    [PipelineRunId]                  NVARCHAR (36)      CONSTRAINT [DF_ItemNotora_PipelineRunId] DEFAULT ('00000000-0000-0000-0000-000000000000') NOT NULL,
    [PipelineTriggerTime]            DATETIMEOFFSET (0) CONSTRAINT [DF_ItemNotora_PipelineTriggerTime] DEFAULT (sysdatetimeoffset()) NOT NULL,
    [CompanyID]                      INT                NOT NULL,
    CONSTRAINT [PK_stg_bc_ItemNotora] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [No_] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

