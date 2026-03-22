CREATE TABLE [stg_navdb].[GLAccount] (
    [CompanyID]                      TINYINT         NOT NULL,
    [timestamp]                      VARBINARY (8)   NULL,
    [No_]                            VARCHAR (20)    NOT NULL,
    [Name]                           VARCHAR (30)    NULL,
    [Search Name]                    VARCHAR (30)    NULL,
    [Account Type]                   INT             NULL,
    [Global Dimension 1 Code]        VARCHAR (20)    NULL,
    [Global Dimension 2 Code]        VARCHAR (20)    NULL,
    [Income_Balance]                 INT             NULL,
    [Debit_Credit]                   INT             NULL,
    [No_ 2]                          VARCHAR (20)    NULL,
    [Blocked]                        TINYINT         NULL,
    [Direct Posting]                 TINYINT         NULL,
    [Reconciliation Account]         TINYINT         NULL,
    [New Page]                       TINYINT         NULL,
    [No_ of Blank Lines]             INT             NULL,
    [Indentation]                    INT             NULL,
    [Last Date Modified]             DATETIME        NULL,
    [Totaling]                       VARCHAR (250)   NULL,
    [Consol_ Translation Method]     INT             NULL,
    [Consol_ Debit Acc_]             VARCHAR (20)    NULL,
    [Consol_ Credit Acc_]            VARCHAR (20)    NULL,
    [Gen_ Posting Type]              INT             NULL,
    [Gen_ Bus_ Posting Group]        VARCHAR (10)    NULL,
    [Gen_ Prod_ Posting Group]       VARCHAR (10)    NULL,
    [Picture]                        VARBINARY (MAX) NULL,
    [Automatic Ext_ Texts]           TINYINT         NULL,
    [Tax Area Code]                  VARCHAR (20)    NULL,
    [Tax Liable]                     TINYINT         NULL,
    [Tax Group Code]                 VARCHAR (10)    NULL,
    [VAT Bus_ Posting Group]         VARCHAR (10)    NULL,
    [VAT Prod_ Posting Group]        VARCHAR (10)    NULL,
    [Exchange Rate Adjustment]       INT             NULL,
    [Default IC Partner G_L Acc_ No] VARCHAR (20)    NULL,
    [Main Group]                     VARCHAR (30)    NULL,
    [Main Group 1]                   VARCHAR (30)    NULL,
    [Sub Group]                      VARCHAR (30)    NULL,
    [F_Main Group]                   VARCHAR (30)    NULL,
    [F_Main Group 1]                 VARCHAR (30)    NULL,
    [F_Sub Group]                    VARCHAR (30)    NULL,
    [PipelineName]                   NVARCHAR (MAX)  NULL,
    [PipelineRunId]                  NVARCHAR (MAX)  NULL,
    [PipelineTriggerTime]            NVARCHAR (MAX)  NULL,
    CONSTRAINT [PK_stg_navdb_GLAccount] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [No_] ASC)
);


GO

CREATE NONCLUSTERED INDEX [ix_stg_navdb_GLAccount_timestamp]
    ON [stg_navdb].[GLAccount]([CompanyID] ASC, [timestamp] ASC);


GO

