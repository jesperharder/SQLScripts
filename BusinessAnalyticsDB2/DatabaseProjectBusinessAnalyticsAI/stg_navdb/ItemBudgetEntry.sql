CREATE TABLE [stg_navdb].[ItemBudgetEntry] (
    [CompanyID]               TINYINT            NOT NULL,
    [timestamp]               VARBINARY (8)      NOT NULL,
    [Entry No_]               INT                NOT NULL,
    [Analysis Area]           INT                NOT NULL,
    [Budget Name]             VARCHAR (10)       NOT NULL,
    [Date]                    DATETIME           NOT NULL,
    [Item No_]                VARCHAR (20)       NOT NULL,
    [Source Type]             INT                NOT NULL,
    [Source No_]              VARCHAR (20)       NOT NULL,
    [Description]             VARCHAR (50)       NOT NULL,
    [Quantity]                DECIMAL (38, 20)   NOT NULL,
    [Cost Amount]             DECIMAL (38, 20)   NOT NULL,
    [Sales Amount]            DECIMAL (38, 20)   NOT NULL,
    [User ID]                 VARCHAR (20)       NOT NULL,
    [Location Code]           VARCHAR (10)       NOT NULL,
    [Global Dimension 1 Code] VARCHAR (20)       NOT NULL,
    [Global Dimension 2 Code] VARCHAR (20)       NOT NULL,
    [Budget Dimension 1 Code] VARCHAR (20)       NOT NULL,
    [Budget Dimension 2 Code] VARCHAR (20)       NOT NULL,
    [Budget Dimension 3 Code] VARCHAR (20)       NOT NULL,
    [Campaign No_]            VARCHAR (10)       NOT NULL,
    [Rolled-up Capacity Cost] DECIMAL (38, 20)   NOT NULL,
    [PipelineName]            NVARCHAR (128)     NULL,
    [PipelineRunId]           NVARCHAR (36)      NULL,
    [PipelineTriggerTime]     DATETIMEOFFSET (0) NULL,
    CONSTRAINT [PK_stg_navdb_ItemBudgetEntry] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [Entry No_] ASC)
);


GO

CREATE NONCLUSTERED INDEX [ix_stg_navdb_ItemBudgetEntry_timestamp]
    ON [stg_navdb].[ItemBudgetEntry]([CompanyID] ASC, [timestamp] ASC);


GO

