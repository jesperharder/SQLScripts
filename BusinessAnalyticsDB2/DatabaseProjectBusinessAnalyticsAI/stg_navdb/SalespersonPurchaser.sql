CREATE TABLE [stg_navdb].[SalespersonPurchaser] (
    [CompanyID]               TINYINT            NOT NULL,
    [timestamp]               VARBINARY (8)      NOT NULL,
    [Code]                    VARCHAR (10)       NOT NULL,
    [Name]                    VARCHAR (50)       NOT NULL,
    [Commission %]            DECIMAL (38, 20)   NOT NULL,
    [Global Dimension 1 Code] VARCHAR (20)       NOT NULL,
    [Global Dimension 2 Code] VARCHAR (20)       NOT NULL,
    [E-Mail]                  VARCHAR (80)       NOT NULL,
    [Phone No_]               VARCHAR (30)       NOT NULL,
    [Job Title]               VARCHAR (30)       NOT NULL,
    [Search E-Mail]           VARCHAR (80)       NOT NULL,
    [E-Mail 2]                VARCHAR (80)       NOT NULL,
    [Comment]                 VARCHAR (80)       NOT NULL,
    [VAT]                     VARCHAR (30)       NOT NULL,
    [PipelineName]            NVARCHAR (128)     NULL,
    [PipelineRunId]           NVARCHAR (36)      NULL,
    [PipelineTriggerTime]     DATETIMEOFFSET (0) NULL,
    CONSTRAINT [PK_stg_navdb_SalespersonPurchaser] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [Code] ASC)
);


GO

CREATE NONCLUSTERED INDEX [ix_stg_navdb_SalespersonPurchaser_timestamp]
    ON [stg_navdb].[SalespersonPurchaser]([CompanyID] ASC, [timestamp] ASC);


GO

