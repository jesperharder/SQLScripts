CREATE TABLE [stg_bc].[ItemUnitofMeasure] (
    [timestamp]                VARBINARY (8)    NULL,
    [Item No_]                 NVARCHAR (20)    NOT NULL,
    [Code]                     NVARCHAR (20)    NOT NULL,
    [Qty_ per Unit of Measure] DECIMAL (38, 20) NULL,
    [Length]                   DECIMAL (38, 20) NULL,
    [Width]                    DECIMAL (38, 20) NULL,
    [Height]                   DECIMAL (38, 20) NULL,
    [Cubage]                   DECIMAL (38, 20) NULL,
    [Weight]                   DECIMAL (38, 20) NULL,
    [$systemId]                UNIQUEIDENTIFIER NULL,
    [$systemCreatedAt]         DATETIME         NULL,
    [$systemCreatedBy]         UNIQUEIDENTIFIER NULL,
    [$systemModifiedAt]        DATETIME         NULL,
    [$systemModifiedBy]        UNIQUEIDENTIFIER NULL,
    [PipelineName]             NVARCHAR (MAX)   NULL,
    [PipelineRunId]            NVARCHAR (MAX)   NULL,
    [PipelineTriggerTime]      NVARCHAR (MAX)   NULL,
    [CompanyID]                INT              NOT NULL,
    CONSTRAINT [PK_stg_bc_ItemUnitofMeasure] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [Item No_] ASC, [Code] ASC)
);


GO

CREATE NONCLUSTERED INDEX [ix_stg_bc_ItemUnitofMeasure_timestamp]
    ON [stg_bc].[ItemUnitofMeasure]([CompanyID] ASC, [timestamp] ASC);


GO

