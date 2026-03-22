CREATE TABLE [stg_bc].[SalespersonPurchaser] (
    [timestamp]               VARBINARY (8)    NOT NULL,
    [Code]                    NVARCHAR (20)    NOT NULL,
    [Name]                    NVARCHAR (50)    NULL,
    [Commission _]            DECIMAL (38, 20) NULL,
    [Image]                   UNIQUEIDENTIFIER NULL,
    [Privacy Blocked]         TINYINT          NULL,
    [Global Dimension 1 Code] NVARCHAR (20)    NULL,
    [Global Dimension 2 Code] NVARCHAR (20)    NULL,
    [E-Mail]                  NVARCHAR (80)    NULL,
    [Phone No_]               NVARCHAR (30)    NULL,
    [Job Title]               NVARCHAR (30)    NULL,
    [Search E-Mail]           NVARCHAR (80)    NULL,
    [E-Mail 2]                NVARCHAR (80)    NULL,
    [$systemId]               UNIQUEIDENTIFIER NULL,
    [$systemCreatedAt]        DATETIME         NULL,
    [$systemCreatedBy]        UNIQUEIDENTIFIER NULL,
    [$systemModifiedAt]       DATETIME         NULL,
    [$systemModifiedBy]       UNIQUEIDENTIFIER NULL,
    [PipelineName]            NVARCHAR (MAX)   NULL,
    [PipelineRunId]           NVARCHAR (MAX)   NULL,
    [PipelineTriggerTime]     NVARCHAR (MAX)   NULL,
    [CompanyID]               INT              NOT NULL,
    CONSTRAINT [PK_stg_bc_SalespersonPurchaser] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [Code] ASC)
);


GO

CREATE NONCLUSTERED INDEX [ix_stg_bc_SalespersonPurchaser_timestamp]
    ON [stg_bc].[SalespersonPurchaser]([CompanyID] ASC, [timestamp] ASC);


GO

