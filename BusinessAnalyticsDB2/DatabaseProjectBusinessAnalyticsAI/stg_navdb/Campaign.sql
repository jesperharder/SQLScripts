CREATE TABLE [stg_navdb].[Campaign] (
    [CompanyID]               TINYINT            NOT NULL,
    [timestamp]               VARBINARY (8)      NOT NULL,
    [No_]                     VARCHAR (20)       NOT NULL,
    [Description]             VARCHAR (50)       NOT NULL,
    [Starting Date]           DATETIME           NOT NULL,
    [Ending Date]             DATETIME           NOT NULL,
    [Salesperson Code]        VARCHAR (10)       NOT NULL,
    [Last Date Modified]      DATETIME           NOT NULL,
    [No_ Series]              VARCHAR (10)       NOT NULL,
    [Global Dimension 1 Code] VARCHAR (20)       NOT NULL,
    [Global Dimension 2 Code] VARCHAR (20)       NOT NULL,
    [Status Code]             VARCHAR (10)       NOT NULL,
    [Selling-in Start Date]   DATETIME           NOT NULL,
    [Selling-in End Date]     DATETIME           NOT NULL,
    [Visible Date]            DATETIME           NOT NULL,
    [Customer Price Group]    VARCHAR (10)       NOT NULL,
    [Document Date]           DATETIME           NOT NULL,
    [Campaign Type]           INT                NOT NULL,
    [PipelineName]            NVARCHAR (128)     NULL,
    [PipelineRunId]           NVARCHAR (36)      NULL,
    [PipelineTriggerTime]     DATETIMEOFFSET (0) NULL,
    CONSTRAINT [PK_stg_navdb_Campaign] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [No_] ASC)
);


GO

CREATE NONCLUSTERED INDEX [ix_stg_navdb_Campaign_timestamp]
    ON [stg_navdb].[Campaign]([CompanyID] ASC, [timestamp] ASC);


GO

