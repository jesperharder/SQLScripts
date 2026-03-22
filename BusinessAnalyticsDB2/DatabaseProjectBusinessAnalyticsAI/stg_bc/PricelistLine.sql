CREATE TABLE [stg_bc].[PricelistLine] (
    [timestamp]                    VARBINARY (8)    NOT NULL,
    [Price List Code]              NVARCHAR (20)    NOT NULL,
    [Line No_]                     INT              NOT NULL,
    [Source Type]                  INT              NULL,
    [Source No_]                   NVARCHAR (20)    NULL,
    [Parent Source No_]            NVARCHAR (20)    NULL,
    [Source ID]                    UNIQUEIDENTIFIER NULL,
    [Asset Type]                   INT              NULL,
    [Asset No_]                    NVARCHAR (20)    NULL,
    [Variant Code]                 NVARCHAR (10)    NULL,
    [Currency Code]                NVARCHAR (10)    NULL,
    [Work Type Code]               NVARCHAR (10)    NULL,
    [Starting Date]                DATETIME         NOT NULL,
    [Ending Date]                  DATETIME         NULL,
    [Minimum Quantity]             DECIMAL (38, 20) NULL,
    [Unit of Measure Code]         NVARCHAR (10)    NULL,
    [Amount Type]                  INT              NULL,
    [Unit Price]                   DECIMAL (38, 20) NULL,
    [Cost Factor]                  DECIMAL (38, 20) NULL,
    [Unit Cost]                    DECIMAL (38, 20) NULL,
    [Line Discount _]              DECIMAL (38, 20) NULL,
    [Allow Line Disc_]             TINYINT          NULL,
    [Allow Invoice Disc_]          TINYINT          NULL,
    [Price Includes VAT]           TINYINT          NULL,
    [VAT Bus_ Posting Gr_ (Price)] NVARCHAR (20)    NULL,
    [VAT Prod_ Posting Group]      NVARCHAR (20)    NULL,
    [Asset ID]                     UNIQUEIDENTIFIER NULL,
    [Line Amount]                  DECIMAL (38, 20) NULL,
    [Price Type]                   INT              NULL,
    [Description]                  NVARCHAR (100)   NULL,
    [Status]                       INT              NULL,
    [Direct Unit Cost]             DECIMAL (38, 20) NULL,
    [Source Group]                 INT              NULL,
    [$systemId]                    UNIQUEIDENTIFIER NULL,
    [$systemCreatedAt]             DATETIME         NULL,
    [$systemCreatedBy]             UNIQUEIDENTIFIER NULL,
    [$systemModifiedAt]            DATETIME         NULL,
    [$systemModifiedBy]            UNIQUEIDENTIFIER NULL,
    [PipelineName]                 NVARCHAR (MAX)   NULL,
    [PipelineRunId]                NVARCHAR (MAX)   NULL,
    [PipelineTriggerTime]          NVARCHAR (MAX)   NULL,
    [CompanyID]                    INT              NOT NULL,
    CONSTRAINT [PK_stg_bc_PricelistLine] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [Price List Code] ASC, [Line No_] ASC)
);


GO

CREATE NONCLUSTERED INDEX [ix_stg_bc_PricelistLine_timestamp]
    ON [stg_bc].[PricelistLine]([CompanyID] ASC, [timestamp] ASC);


GO

