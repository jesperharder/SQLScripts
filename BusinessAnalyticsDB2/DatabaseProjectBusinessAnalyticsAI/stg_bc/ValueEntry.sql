CREATE TABLE [stg_bc].[ValueEntry] (
    [timestamp]                      VARBINARY (8)    NOT NULL,
    [Entry No_]                      INT              NOT NULL,
    [Item No_]                       NVARCHAR (20)    NOT NULL,
    [Posting Date]                   DATETIME         NOT NULL,
    [Item Ledger Entry Type]         INT              NULL,
    [Source No_]                     NVARCHAR (20)    NULL,
    [Document No_]                   NVARCHAR (20)    NULL,
    [Description]                    NVARCHAR (100)   NULL,
    [Location Code]                  NVARCHAR (10)    NULL,
    [Inventory Posting Group]        NVARCHAR (20)    NULL,
    [Source Posting Group]           NVARCHAR (20)    NULL,
    [Item Ledger Entry No_]          INT              NULL,
    [Valued Quantity]                DECIMAL (38, 20) NULL,
    [Item Ledger Entry Quantity]     DECIMAL (38, 20) NULL,
    [Invoiced Quantity]              DECIMAL (38, 20) NULL,
    [Cost per Unit]                  DECIMAL (38, 20) NULL,
    [Sales Amount (Actual)]          DECIMAL (38, 20) NULL,
    [Salespers__Purch_ Code]         NVARCHAR (20)    NULL,
    [Discount Amount]                DECIMAL (38, 20) NULL,
    [User ID]                        NVARCHAR (50)    NULL,
    [Source Code]                    NVARCHAR (10)    NULL,
    [Applies-to Entry]               INT              NULL,
    [Global Dimension 1 Code]        NVARCHAR (20)    NULL,
    [Global Dimension 2 Code]        NVARCHAR (20)    NULL,
    [Source Type]                    INT              NULL,
    [Cost Amount (Actual)]           DECIMAL (38, 20) NULL,
    [Cost Posted to G_L]             DECIMAL (38, 20) NULL,
    [Reason Code]                    NVARCHAR (10)    NULL,
    [Drop Shipment]                  TINYINT          NULL,
    [Journal Batch Name]             NVARCHAR (10)    NULL,
    [Gen_ Bus_ Posting Group]        NVARCHAR (20)    NULL,
    [Gen_ Prod_ Posting Group]       NVARCHAR (20)    NULL,
    [Document Date]                  DATETIME         NULL,
    [External Document No_]          NVARCHAR (35)    NULL,
    [Cost Amount (Actual) (ACY)]     DECIMAL (38, 20) NULL,
    [Cost Posted to G_L (ACY)]       DECIMAL (38, 20) NULL,
    [Cost per Unit (ACY)]            DECIMAL (38, 20) NULL,
    [Document Type]                  INT              NOT NULL,
    [Document Line No_]              INT              NULL,
    [Order Type]                     INT              NULL,
    [Order No_]                      NVARCHAR (20)    NULL,
    [Order Line No_]                 INT              NULL,
    [Expected Cost]                  TINYINT          NULL,
    [Item Charge No_]                NVARCHAR (20)    NULL,
    [Valued By Average Cost]         TINYINT          NULL,
    [Partial Revaluation]            TINYINT          NULL,
    [Inventoriable]                  TINYINT          NULL,
    [Valuation Date]                 DATETIME         NULL,
    [Entry Type]                     INT              NULL,
    [Variance Type]                  INT              NULL,
    [Purchase Amount (Actual)]       DECIMAL (38, 20) NULL,
    [Purchase Amount (Expected)]     DECIMAL (38, 20) NULL,
    [Sales Amount (Expected)]        DECIMAL (38, 20) NULL,
    [Cost Amount (Expected)]         DECIMAL (38, 20) NULL,
    [Cost Amount (Non-Invtbl_)]      DECIMAL (38, 20) NULL,
    [Cost Amount (Expected) (ACY)]   DECIMAL (38, 20) NULL,
    [Cost Amount (Non-Invtbl_)(ACY)] DECIMAL (38, 20) NULL,
    [Expected Cost Posted to G_L]    DECIMAL (38, 20) NULL,
    [Exp_ Cost Posted to G_L (ACY)]  DECIMAL (38, 20) NULL,
    [Dimension Set ID]               INT              NOT NULL,
    [Job No_]                        NVARCHAR (20)    NULL,
    [Job Task No_]                   NVARCHAR (20)    NULL,
    [Job Ledger Entry No_]           INT              NULL,
    [Variant Code]                   NVARCHAR (10)    NULL,
    [Adjustment]                     TINYINT          NULL,
    [Average Cost Exception]         TINYINT          NULL,
    [Capacity Ledger Entry No_]      INT              NULL,
    [Type]                           INT              NULL,
    [No_]                            NVARCHAR (20)    NOT NULL,
    [Return Reason Code]             NVARCHAR (10)    NULL,
    [$systemId]                      UNIQUEIDENTIFIER NULL,
    [$systemCreatedAt]               DATETIME         NULL,
    [$systemCreatedBy]               UNIQUEIDENTIFIER NULL,
    [$systemModifiedAt]              DATETIME         NULL,
    [$systemModifiedBy]              UNIQUEIDENTIFIER NULL,
    [PipelineName]                   NVARCHAR (MAX)   NULL,
    [PipelineRunId]                  NVARCHAR (MAX)   NULL,
    [PipelineTriggerTime]            NVARCHAR (MAX)   NULL,
    [CompanyID]                      INT              NOT NULL,
    CONSTRAINT [PK_stg_bc_ValueEntry] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [Entry No_] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

CREATE NONCLUSTERED INDEX [NIX_stg_bc_ValueEntry_CompanyID_timestamp_PostingDate_ItemLegderEntryQuantity_WithIncluded]
    ON [stg_bc].[ValueEntry]([CompanyID] ASC, [timestamp] ASC, [Posting Date] ASC, [Item Ledger Entry Quantity] ASC)
    INCLUDE([Item No_], [Item Ledger Entry Type], [Source No_], [Document No_], [Location Code], [Item Ledger Entry No_], [User ID], [Global Dimension 1 Code], [Reason Code], [Gen_ Bus_ Posting Group], [Gen_ Prod_ Posting Group]) WITH (DATA_COMPRESSION = ROW);


GO

CREATE NONCLUSTERED INDEX [NIX_stg_bc_ValueEntry_ItemLedgerEntryNo_CompanyID_WithIncluded]
    ON [stg_bc].[ValueEntry]([Item Ledger Entry No_] ASC, [CompanyID] ASC)
    INCLUDE([Item No_], [Posting Date], [Item Ledger Entry Type], [Document No_], [Location Code], [Item Ledger Entry Quantity], [Global Dimension 1 Code], [Gen_ Bus_ Posting Group], [Gen_ Prod_ Posting Group]) WITH (DATA_COMPRESSION = ROW);


GO

CREATE NONCLUSTERED INDEX [IX_stg_bc_ValueEntry_CompanyID_timestamp]
    ON [stg_bc].[ValueEntry]([CompanyID] ASC, [timestamp] ASC);


GO

