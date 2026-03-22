CREATE TABLE [stg_bc].[DefaultDimension] (
    [timestamp]              VARBINARY (8)    NULL,
    [Table ID]               INT              NULL,
    [No_]                    NVARCHAR (20)    NULL,
    [Dimension Code]         NVARCHAR (20)    NULL,
    [Dimension Value Code]   NVARCHAR (20)    NULL,
    [Value Posting]          INT              NULL,
    [Multi Selection Action] INT              NULL,
    [Parent Type]            INT              NULL,
    [Allowed Values Filter]  NVARCHAR (250)   NULL,
    [ParentId]               UNIQUEIDENTIFIER NULL,
    [DimensionId]            UNIQUEIDENTIFIER NULL,
    [DimensionValueId]       UNIQUEIDENTIFIER NULL,
    [$systemId]              UNIQUEIDENTIFIER NULL,
    [$systemCreatedAt]       DATETIME         NULL,
    [$systemCreatedBy]       UNIQUEIDENTIFIER NULL,
    [$systemModifiedAt]      DATETIME         NULL,
    [$systemModifiedBy]      UNIQUEIDENTIFIER NULL,
    [PipelineName]           NVARCHAR (MAX)   NULL,
    [PipelineRunId]          NVARCHAR (MAX)   NULL,
    [PipelineTriggerTime]    NVARCHAR (MAX)   NULL,
    [CompanyID]              NVARCHAR (MAX)   NULL
);


GO

