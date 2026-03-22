CREATE TABLE [stg_navdb].[FixedAsset] (
    [CompanyID]               TINYINT            NOT NULL,
    [timestamp]               VARBINARY (8)      NOT NULL,
    [No_]                     VARCHAR (20)       NOT NULL,
    [Description]             VARCHAR (30)       NOT NULL,
    [Search Description]      VARCHAR (30)       NOT NULL,
    [Description 2]           VARCHAR (30)       NOT NULL,
    [FA Class Code]           VARCHAR (10)       NOT NULL,
    [FA Subclass Code]        VARCHAR (10)       NOT NULL,
    [Global Dimension 1 Code] VARCHAR (20)       NOT NULL,
    [Global Dimension 2 Code] VARCHAR (20)       NOT NULL,
    [Location Code]           VARCHAR (10)       NOT NULL,
    [FA Location Code]        VARCHAR (10)       NOT NULL,
    [Vendor No_]              VARCHAR (20)       NOT NULL,
    [Main Asset_Component]    INT                NOT NULL,
    [Component of Main Asset] VARCHAR (20)       NOT NULL,
    [Budgeted Asset]          TINYINT            NOT NULL,
    [Warranty Date]           DATETIME           NOT NULL,
    [Responsible Employee]    VARCHAR (20)       NOT NULL,
    [Serial No_]              VARCHAR (30)       NOT NULL,
    [Last Date Modified]      DATETIME           NOT NULL,
    [Blocked]                 TINYINT            NOT NULL,
    [Picture]                 VARBINARY (MAX)    NULL,
    [Maintenance Vendor No_]  VARCHAR (20)       NOT NULL,
    [Under Maintenance]       TINYINT            NOT NULL,
    [Next Service Date]       DATETIME           NOT NULL,
    [Inactive]                TINYINT            NOT NULL,
    [No_ Series]              VARCHAR (10)       NOT NULL,
    [FA Posting Group]        VARCHAR (10)       NOT NULL,
    [PipelineName]            NVARCHAR (128)     NULL,
    [PipelineRunId]           NVARCHAR (36)      NULL,
    [PipelineTriggerTime]     DATETIMEOFFSET (0) NULL,
    CONSTRAINT [PK_stg_navdb_FixedAsset] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [No_] ASC)
);


GO

CREATE NONCLUSTERED INDEX [ix_stg_navdb_FixedAsset_timestamp]
    ON [stg_navdb].[FixedAsset]([CompanyID] ASC, [timestamp] ASC);


GO

