CREATE TABLE [stg_bc].[GLAccount] (
    [timestamp]                      VARBINARY (8)    NOT NULL,
    [No_]                            NVARCHAR (20)    NOT NULL,
    [Name]                           NVARCHAR (100)   NULL,
    [Search Name]                    NVARCHAR (100)   NULL,
    [Account Type]                   INT              NULL,
    [Global Dimension 1 Code]        NVARCHAR (20)    NULL,
    [Global Dimension 2 Code]        NVARCHAR (20)    NULL,
    [Account Category]               INT              NULL,
    [Income_Balance]                 INT              NULL,
    [Debit_Credit]                   INT              NULL,
    [No_ 2]                          NVARCHAR (20)    NULL,
    [Blocked]                        TINYINT          NULL,
    [Direct Posting]                 TINYINT          NULL,
    [Reconciliation Account]         TINYINT          NULL,
    [New Page]                       TINYINT          NULL,
    [No_ of Blank Lines]             INT              NULL,
    [Indentation]                    INT              NULL,
    [Last Modified Date Time]        DATETIME         NULL,
    [Last Date Modified]             DATETIME         NULL,
    [Totaling]                       NVARCHAR (250)   NULL,
    [Consol_ Translation Method]     INT              NULL,
    [Consol_ Debit Acc_]             NVARCHAR (20)    NULL,
    [Consol_ Credit Acc_]            NVARCHAR (20)    NULL,
    [Gen_ Posting Type]              INT              NULL,
    [Gen_ Bus_ Posting Group]        NVARCHAR (20)    NULL,
    [Gen_ Prod_ Posting Group]       NVARCHAR (20)    NULL,
    [Picture]                        VARBINARY (MAX)  NULL,
    [Automatic Ext_ Texts]           TINYINT          NULL,
    [Tax Area Code]                  NVARCHAR (20)    NULL,
    [Tax Liable]                     TINYINT          NULL,
    [Tax Group Code]                 NVARCHAR (20)    NULL,
    [VAT Bus_ Posting Group]         NVARCHAR (20)    NULL,
    [VAT Prod_ Posting Group]        NVARCHAR (20)    NULL,
    [Exchange Rate Adjustment]       INT              NULL,
    [Default IC Partner G_L Acc_ No] NVARCHAR (20)    NULL,
    [Omit Default Descr_ in Jnl_]    TINYINT          NULL,
    [Account Subcategory Entry No_]  INT              NULL,
    [Cost Type No_]                  NVARCHAR (20)    NULL,
    [Default Deferral Template Code] NVARCHAR (10)    NULL,
    [Id]                             UNIQUEIDENTIFIER NULL,
    [API Account Type]               INT              NULL,
    [$systemId]                      UNIQUEIDENTIFIER NULL,
    [$systemCreatedAt]               DATETIME         NULL,
    [$systemCreatedBy]               UNIQUEIDENTIFIER NULL,
    [$systemModifiedAt]              DATETIME         NULL,
    [$systemModifiedBy]              UNIQUEIDENTIFIER NULL,
    [PipelineName]                   NVARCHAR (MAX)   NULL,
    [PipelineRunId]                  NVARCHAR (MAX)   NULL,
    [PipelineTriggerTime]            NVARCHAR (MAX)   NULL,
    [CompanyID]                      INT              NOT NULL,
    CONSTRAINT [PK_stg_bc_GLAccount] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [No_] ASC)
);


GO

CREATE NONCLUSTERED INDEX [ix_stg_bc_GLAccount_timestamp]
    ON [stg_bc].[GLAccount]([CompanyID] ASC, [timestamp] ASC);


GO

