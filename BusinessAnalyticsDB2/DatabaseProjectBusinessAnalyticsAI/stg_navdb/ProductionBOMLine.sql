CREATE TABLE [stg_navdb].[ProductionBOMLine] (
    [timestamp]            VARBINARY (8)      NOT NULL,
    [Production BOM No_]   VARCHAR (20)       NOT NULL,
    [Version Code]         VARCHAR (10)       NOT NULL,
    [Line No_]             INT                NOT NULL,
    [Type]                 INT                NOT NULL,
    [No_]                  VARCHAR (20)       NOT NULL,
    [Description]          VARCHAR (30)       NOT NULL,
    [Unit of Measure Code] VARCHAR (10)       NOT NULL,
    [Quantity]             DECIMAL (38, 10)   NOT NULL,
    [Position]             VARCHAR (10)       NOT NULL,
    [Position 2]           VARCHAR (10)       NOT NULL,
    [Position 3]           VARCHAR (10)       NOT NULL,
    [Production Lead Time] VARCHAR (32)       NOT NULL,
    [Routing Link Code]    VARCHAR (10)       NOT NULL,
    [Scrap %]              DECIMAL (38, 10)   NOT NULL,
    [Variant Code]         VARCHAR (10)       NOT NULL,
    [Starting Date]        DATETIME           NOT NULL,
    [Ending Date]          DATETIME           NOT NULL,
    [Length]               DECIMAL (38, 10)   NOT NULL,
    [Width]                DECIMAL (38, 10)   NOT NULL,
    [Weight]               DECIMAL (38, 10)   NOT NULL,
    [Depth]                DECIMAL (38, 10)   NOT NULL,
    [Calculation Formula]  INT                NOT NULL,
    [Quantity per]         DECIMAL (38, 10)   NOT NULL,
    [PipelineName]         NVARCHAR (200)     CONSTRAINT [DF_ProductionBOMLine_PipelineName] DEFAULT ('Default') NOT NULL,
    [PipelineRunId]        NVARCHAR (36)      CONSTRAINT [DF_ProductionBOMLine_PipelineRunId] DEFAULT ('00000000-0000-0000-0000-000000000000') NOT NULL,
    [PipelineTriggerTime]  DATETIMEOFFSET (0) CONSTRAINT [DF_ProductionBOMLine_PipelineTriggerTime] DEFAULT (sysdatetimeoffset()) NOT NULL,
    [CompanyID]            INT                NOT NULL,
    CONSTRAINT [PK_stg_navdb_ProductionBOMLine] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [Production BOM No_] ASC, [Version Code] ASC, [Line No_] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

