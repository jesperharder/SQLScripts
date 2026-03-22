CREATE TABLE [stg_bc].[ItemBudgetEntry] (
    [timestamp]               VARBINARY (8)    NOT NULL,
    [Entry No_]               INT              NOT NULL,
    [Analysis Area]           INT              NULL,
    [Budget Name]             NVARCHAR (20)    NOT NULL,
    [Date]                    DATETIME         NOT NULL,
    [Item No_]                NVARCHAR (20)    NULL,
    [Source Type]             INT              NULL,
    [Source No_]              NVARCHAR (20)    NULL,
    [Description]             NVARCHAR (100)   NULL,
    [Quantity]                DECIMAL (38, 20) NULL,
    [Cost Amount]             DECIMAL (38, 20) NULL,
    [Sales Amount]            DECIMAL (38, 20) NULL,
    [User ID]                 NVARCHAR (50)    NULL,
    [Location Code]           NVARCHAR (10)    NULL,
    [Global Dimension 1 Code] NVARCHAR (20)    NULL,
    [Global Dimension 2 Code] NVARCHAR (20)    NULL,
    [Budget Dimension 1 Code] NVARCHAR (20)    NULL,
    [Budget Dimension 2 Code] NVARCHAR (20)    NULL,
    [Budget Dimension 3 Code] NVARCHAR (20)    NULL,
    [Dimension Set ID]        INT              NOT NULL,
    [$systemId]               UNIQUEIDENTIFIER NULL,
    [$systemCreatedAt]        DATETIME         NULL,
    [$systemCreatedBy]        UNIQUEIDENTIFIER NULL,
    [$systemModifiedAt]       DATETIME         NULL,
    [$systemModifiedBy]       UNIQUEIDENTIFIER NULL,
    [PipelineName]            NVARCHAR (MAX)   NULL,
    [PipelineRunId]           NVARCHAR (MAX)   NULL,
    [PipelineTriggerTime]     NVARCHAR (MAX)   NULL,
    [CompanyID]               INT              NOT NULL,
    CONSTRAINT [PK_stg_bc_ItemBudgetEntry] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [Entry No_] ASC)
);


GO

CREATE NONCLUSTERED INDEX [ix_stg_bc_ItemBudgetEntry_timestamp]
    ON [stg_bc].[ItemBudgetEntry]([CompanyID] ASC, [timestamp] ASC);


GO

