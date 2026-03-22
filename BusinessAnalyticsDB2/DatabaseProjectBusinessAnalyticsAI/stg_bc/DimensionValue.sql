CREATE TABLE [stg_bc].[DimensionValue] (
    [timestamp]                      VARBINARY (8)    NOT NULL,
    [Dimension Code]                 NVARCHAR (20)    NOT NULL,
    [Code]                           NVARCHAR (20)    NOT NULL,
    [Name]                           NVARCHAR (50)    NULL,
    [Dimension Value Type]           INT              NULL,
    [Totaling]                       NVARCHAR (250)   NULL,
    [Blocked]                        TINYINT          NULL,
    [Consolidation Code]             NVARCHAR (20)    NULL,
    [Indentation]                    INT              NULL,
    [Global Dimension No_]           INT              NULL,
    [Map-to IC Dimension Code]       NVARCHAR (20)    NULL,
    [Map-to IC Dimension Value Code] NVARCHAR (20)    NULL,
    [Dimension Value ID]             INT              NULL,
    [Id]                             UNIQUEIDENTIFIER NULL,
    [Last Modified Date Time]        DATETIME         NULL,
    [Dimension Id]                   UNIQUEIDENTIFIER NULL,
    [$systemId]                      UNIQUEIDENTIFIER NULL,
    [$systemCreatedAt]               DATETIME         NULL,
    [$systemCreatedBy]               UNIQUEIDENTIFIER NULL,
    [$systemModifiedAt]              DATETIME         NULL,
    [$systemModifiedBy]              UNIQUEIDENTIFIER NULL,
    [PipelineName]                   NVARCHAR (MAX)   NULL,
    [PipelineRunId]                  NVARCHAR (MAX)   NULL,
    [PipelineTriggerTime]            NVARCHAR (MAX)   NULL,
    [CompanyID]                      INT              NOT NULL,
    CONSTRAINT [PK_stg_bc_DimensionValue] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [Dimension Code] ASC, [Code] ASC)
);


GO

CREATE NONCLUSTERED INDEX [ix_stg_bc_DimensionValue_timestamp]
    ON [stg_bc].[DimensionValue]([CompanyID] ASC, [timestamp] ASC);


GO

