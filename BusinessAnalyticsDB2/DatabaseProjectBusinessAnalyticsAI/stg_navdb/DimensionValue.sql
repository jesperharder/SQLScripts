CREATE TABLE [stg_navdb].[DimensionValue] (
    [CompanyID]                      TINYINT            NOT NULL,
    [timestamp]                      VARBINARY (8)      NOT NULL,
    [Dimension Code]                 VARCHAR (20)       NOT NULL,
    [Code]                           VARCHAR (20)       NOT NULL,
    [Name]                           VARCHAR (50)       NOT NULL,
    [Dimension Value Type]           INT                NOT NULL,
    [Totaling]                       VARCHAR (250)      NOT NULL,
    [Blocked]                        TINYINT            NOT NULL,
    [Consolidation Code]             VARCHAR (20)       NOT NULL,
    [Indentation]                    INT                NOT NULL,
    [Global Dimension No_]           INT                NOT NULL,
    [Map-to IC Dimension Code]       VARCHAR (20)       NOT NULL,
    [Map-to IC Dimension Value Code] VARCHAR (20)       NOT NULL,
    [Responsible Dimension]          VARCHAR (20)       NOT NULL,
    [Responsible Dimension Name]     VARCHAR (50)       NOT NULL,
    [Transfer to the Lessor Portal]  TINYINT            NOT NULL,
    [PipelineName]                   NVARCHAR (128)     NULL,
    [PipelineRunId]                  NVARCHAR (36)      NULL,
    [PipelineTriggerTime]            DATETIMEOFFSET (0) NULL,
    CONSTRAINT [PK_stg_navdb_DimensionValue] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [Dimension Code] ASC, [Code] ASC)
);


GO

CREATE NONCLUSTERED INDEX [ix_stg_navdb_DimensionValue_timestamp]
    ON [stg_navdb].[DimensionValue]([CompanyID] ASC, [timestamp] ASC);


GO

