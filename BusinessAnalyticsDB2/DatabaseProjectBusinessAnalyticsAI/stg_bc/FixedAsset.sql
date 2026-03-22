CREATE TABLE [stg_bc].[FixedAsset] (
    [timestamp]               VARBINARY (8)    NOT NULL,
    [No_]                     NVARCHAR (20)    NOT NULL,
    [Description]             NVARCHAR (100)   NULL,
    [Search Description]      NVARCHAR (100)   NULL,
    [Description 2]           NVARCHAR (50)    NULL,
    [FA Class Code]           NVARCHAR (10)    NULL,
    [FA Subclass Code]        NVARCHAR (10)    NULL,
    [Global Dimension 1 Code] NVARCHAR (20)    NULL,
    [Global Dimension 2 Code] NVARCHAR (20)    NULL,
    [Location Code]           NVARCHAR (10)    NULL,
    [FA Location Code]        NVARCHAR (10)    NULL,
    [Vendor No_]              NVARCHAR (20)    NULL,
    [Main Asset_Component]    INT              NULL,
    [Component of Main Asset] NVARCHAR (20)    NULL,
    [Budgeted Asset]          TINYINT          NULL,
    [Warranty Date]           DATETIME         NULL,
    [Responsible Employee]    NVARCHAR (20)    NULL,
    [Serial No_]              NVARCHAR (50)    NULL,
    [Last Date Modified]      DATETIME         NULL,
    [Blocked]                 TINYINT          NULL,
    [Picture]                 VARBINARY (MAX)  NULL,
    [Maintenance Vendor No_]  NVARCHAR (20)    NULL,
    [Under Maintenance]       TINYINT          NULL,
    [Next Service Date]       DATETIME         NULL,
    [Inactive]                TINYINT          NULL,
    [No_ Series]              NVARCHAR (20)    NULL,
    [FA Posting Group]        NVARCHAR (20)    NULL,
    [Image]                   UNIQUEIDENTIFIER NULL,
    [$systemId]               UNIQUEIDENTIFIER NULL,
    [$systemCreatedAt]        DATETIME         NULL,
    [$systemCreatedBy]        UNIQUEIDENTIFIER NULL,
    [$systemModifiedAt]       DATETIME         NULL,
    [$systemModifiedBy]       UNIQUEIDENTIFIER NULL,
    [PipelineName]            NVARCHAR (MAX)   NULL,
    [PipelineRunId]           NVARCHAR (MAX)   NULL,
    [PipelineTriggerTime]     NVARCHAR (MAX)   NULL,
    [CompanyID]               INT              NOT NULL,
    CONSTRAINT [PK_stg_bc_FixedAsset] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [No_] ASC)
);


GO

CREATE NONCLUSTERED INDEX [ix_stg_bc_FixedAsset_timestamp]
    ON [stg_bc].[FixedAsset]([CompanyID] ASC, [timestamp] ASC);


GO

