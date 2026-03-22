CREATE TABLE [stg_navdb].[ValueEntry] (
    [CompanyID]                      TINYINT            NOT NULL,
    [timestamp]                      VARBINARY (8)      NULL,
    [Entry No_]                      INT                NOT NULL,
    [Item No_]                       VARCHAR (20)       NULL,
    [Posting Date]                   DATETIME           NOT NULL,
    [Item Ledger Entry Type]         INT                NULL,
    [Source No_]                     VARCHAR (20)       NULL,
    [Document No_]                   VARCHAR (20)       NULL,
    [Description]                    VARCHAR (50)       NULL,
    [Location Code]                  VARCHAR (10)       NULL,
    [Inventory Posting Group]        VARCHAR (10)       NULL,
    [Source Posting Group]           VARCHAR (10)       NULL,
    [Item Ledger Entry No_]          INT                NULL,
    [Valued Quantity]                DECIMAL (38, 20)   NULL,
    [Item Ledger Entry Quantity]     DECIMAL (38, 20)   NULL,
    [Invoiced Quantity]              DECIMAL (38, 20)   NULL,
    [Cost per Unit]                  DECIMAL (38, 20)   NULL,
    [Sales Amount (Actual)]          DECIMAL (38, 20)   NULL,
    [Salespers__Purch_ Code]         VARCHAR (10)       NULL,
    [Discount Amount]                DECIMAL (38, 20)   NULL,
    [User ID]                        VARCHAR (20)       NULL,
    [Source Code]                    VARCHAR (10)       NULL,
    [Applies-to Entry]               INT                NULL,
    [Global Dimension 1 Code]        VARCHAR (20)       NULL,
    [Global Dimension 2 Code]        VARCHAR (20)       NULL,
    [Source Type]                    INT                NULL,
    [Cost Amount (Actual)]           DECIMAL (38, 20)   NULL,
    [Cost Posted to G_L]             DECIMAL (38, 20)   NULL,
    [Reason Code]                    VARCHAR (10)       NULL,
    [Drop Shipment]                  TINYINT            NULL,
    [Journal Batch Name]             VARCHAR (10)       NULL,
    [Gen_ Bus_ Posting Group]        VARCHAR (10)       NULL,
    [Gen_ Prod_ Posting Group]       VARCHAR (10)       NULL,
    [Document Date]                  DATETIME           NULL,
    [External Document No_]          VARCHAR (20)       NULL,
    [Cost Amount (Actual) (ACY)]     DECIMAL (38, 20)   NULL,
    [Cost Posted to G_L (ACY)]       DECIMAL (38, 20)   NULL,
    [Cost per Unit (ACY)]            DECIMAL (38, 20)   NULL,
    [Document Type]                  INT                NULL,
    [Document Line No_]              INT                NULL,
    [Expected Cost]                  TINYINT            NULL,
    [Item Charge No_]                VARCHAR (20)       NULL,
    [Valued By Average Cost]         TINYINT            NULL,
    [Partial Revaluation]            TINYINT            NULL,
    [Inventoriable]                  TINYINT            NULL,
    [Valuation Date]                 DATETIME           NULL,
    [Entry Type]                     INT                NULL,
    [Variance Type]                  INT                NULL,
    [Purchase Amount (Actual)]       DECIMAL (38, 20)   NULL,
    [Purchase Amount (Expected)]     DECIMAL (38, 20)   NULL,
    [Sales Amount (Expected)]        DECIMAL (38, 20)   NULL,
    [Cost Amount (Expected)]         DECIMAL (38, 20)   NULL,
    [Cost Amount (Non-Invtbl_)]      DECIMAL (38, 20)   NULL,
    [Cost Amount (Expected) (ACY)]   DECIMAL (38, 20)   NULL,
    [Cost Amount (Non-Invtbl_)(ACY)] DECIMAL (38, 20)   NULL,
    [Expected Cost Posted to G_L]    DECIMAL (38, 20)   NULL,
    [Exp_ Cost Posted to G_L (ACY)]  DECIMAL (38, 20)   NULL,
    [Job No_]                        VARCHAR (20)       NULL,
    [Job Task No_]                   VARCHAR (20)       NULL,
    [Prod_ Order No_]                VARCHAR (20)       NULL,
    [Variant Code]                   VARCHAR (10)       NULL,
    [Adjustment]                     TINYINT            NULL,
    [Average Cost Exception]         TINYINT            NULL,
    [Capacity Ledger Entry No_]      INT                NULL,
    [Type]                           INT                NULL,
    [No_]                            VARCHAR (20)       NULL,
    [Prod_ Order Line No_]           INT                NULL,
    [Return Reason Code]             VARCHAR (10)       NULL,
    [YearCode Text]                  VARCHAR (10)       NULL,
    [Item Category Code]             VARCHAR (10)       NULL,
    [Product Group Code]             VARCHAR (10)       NULL,
    [Unit Cost II (LCY)]             DECIMAL (38, 20)   NULL,
    [Product Line Code]              VARCHAR (10)       NULL,
    [Item Brand]                     VARCHAR (10)       NULL,
    [Campaign No_]                   VARCHAR (20)       NULL,
    [Normal Net Price]               DECIMAL (38, 20)   NULL,
    [Normal Net Amount]              DECIMAL (38, 20)   NULL,
    [PipelineName]                   NVARCHAR (MAX)     NULL,
    [PipelineRunId]                  NVARCHAR (MAX)     NULL,
    [PipelineTriggerTime]            DATETIMEOFFSET (0) NULL,
    CONSTRAINT [PK_stg_navdb_ValueEntry] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [Posting Date] ASC, [Entry No_] ASC)
);


GO

CREATE NONCLUSTERED INDEX [NIX_stg_navdb_ValueEntry_CompamyID_timestamp_ItemLedgerEntryQuantity_WithIncluded]
    ON [stg_navdb].[ValueEntry]([CompanyID] ASC, [timestamp] ASC, [Item Ledger Entry Quantity] ASC)
    INCLUDE([Item No_], [Item Ledger Entry Type], [Source No_], [Document No_], [Location Code], [Item Ledger Entry No_], [User ID], [Global Dimension 1 Code], [Reason Code], [Gen_ Bus_ Posting Group], [Gen_ Prod_ Posting Group]) WITH (DATA_COMPRESSION = ROW);


GO

CREATE NONCLUSTERED INDEX [NIX_stg_navdb_ValueEntry_CompamyID_ItemNo_timestamp_PostingDate_WithIncluded]
    ON [stg_navdb].[ValueEntry]([CompanyID] ASC, [Item No_] ASC, [timestamp] ASC, [Posting Date] ASC)
    INCLUDE([Item Ledger Entry Type], [Source No_], [Document No_], [Location Code], [Item Ledger Entry No_], [Item Ledger Entry Quantity], [User ID], [Global Dimension 1 Code], [Reason Code], [Gen_ Bus_ Posting Group], [Gen_ Prod_ Posting Group]) WITH (DATA_COMPRESSION = ROW);


GO

CREATE NONCLUSTERED INDEX [ix_stg_navdb_ValueEntry_timestamp]
    ON [stg_navdb].[ValueEntry]([CompanyID] ASC, [timestamp] ASC);


GO

