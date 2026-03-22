CREATE TABLE [stg_bc_api].[ValueEntry] (
    [CompanyId]               INT              NOT NULL,
    [entryNo]                 INT              NOT NULL,
    [systemId]                UNIQUEIDENTIFIER NULL,
    [itemNo]                  NVARCHAR (20)    NOT NULL,
    [description]             NVARCHAR (100)   NOT NULL,
    [variantCode]             NVARCHAR (10)    NOT NULL,
    [locationCode]            NVARCHAR (10)    NOT NULL,
    [itemLedgerEntryNo]       INT              NOT NULL,
    [postingDate]             DATE             NOT NULL,
    [documentDate]            DATE             NULL,
    [valuationDate]           DATE             NULL,
    [documentType]            NVARCHAR (50)    NOT NULL,
    [documentTypeInt]         INT              NOT NULL,
    [documentNo]              NVARCHAR (20)    NOT NULL,
    [documentLineNo]          INT              NOT NULL,
    [externalDocumentNo]      NVARCHAR (35)    NOT NULL,
    [entryType]               NVARCHAR (50)    NOT NULL,
    [entryTypeInt]            INT              NOT NULL,
    [itemLedgerEntryType]     NVARCHAR (50)    NOT NULL,
    [itemLedgerEntryTypeInt]  INT              NOT NULL,
    [sourceType]              NVARCHAR (50)    NOT NULL,
    [sourceTypeInt]           INT              NOT NULL,
    [sourceNo]                NVARCHAR (20)    NOT NULL,
    [sourceCode]              NVARCHAR (10)    NOT NULL,
    [orderType]               NVARCHAR (50)    NOT NULL,
    [orderTypeInt]            INT              NOT NULL,
    [orderNo]                 NVARCHAR (20)    NOT NULL,
    [orderLineNo]             INT              NOT NULL,
    [varianceType]            NVARCHAR (50)    NOT NULL,
    [varianceTypeInt]         INT              NOT NULL,
    [globalDim1Code]          NVARCHAR (20)    NOT NULL,
    [globalDim2Code]          NVARCHAR (20)    NOT NULL,
    [shortcutDimension3Code]  NVARCHAR (20)    NOT NULL,
    [shortcutDimension4Code]  NVARCHAR (20)    NOT NULL,
    [shortcutDimension5Code]  NVARCHAR (20)    NOT NULL,
    [shortcutDimension6Code]  NVARCHAR (20)    NOT NULL,
    [shortcutDimension7Code]  NVARCHAR (20)    NOT NULL,
    [shortcutDimension8Code]  NVARCHAR (20)    NOT NULL,
    [dimensionSetId]          INT              NOT NULL,
    [inventoryPostingGroup]   NVARCHAR (20)    NOT NULL,
    [sourcePostingGroup]      NVARCHAR (20)    NOT NULL,
    [genBusPostingGroup]      NVARCHAR (20)    NOT NULL,
    [genProdPostingGroup]     NVARCHAR (20)    NOT NULL,
    [valuedQuantity]          DECIMAL (38, 20) NOT NULL,
    [itemLedgerEntryQuantity] DECIMAL (38, 20) NOT NULL,
    [invoicedQuantity]        DECIMAL (38, 20) NOT NULL,
    [costPerUnit]             DECIMAL (38, 20) NOT NULL,
    [costPerUnitACY]          DECIMAL (38, 20) NOT NULL,
    [costAmountActual]        DECIMAL (38, 20) NOT NULL,
    [costAmountExpected]      DECIMAL (38, 20) NOT NULL,
    [costAmountNonInvtbl]     DECIMAL (38, 20) NOT NULL,
    [costPostedToGL]          DECIMAL (38, 20) NOT NULL,
    [expectedCostPostedToGL]  DECIMAL (38, 20) NOT NULL,
    [costAmountActualACY]     DECIMAL (38, 20) NOT NULL,
    [costAmountExpectedACY]   DECIMAL (38, 20) NOT NULL,
    [costAmountNonInvtblACY]  DECIMAL (38, 20) NOT NULL,
    [costPostedToGLACY]       DECIMAL (38, 20) NOT NULL,
    [expCostPostedToGLACY]    DECIMAL (38, 20) NOT NULL,
    [salesAmountActual]       DECIMAL (38, 20) NOT NULL,
    [salesAmountExpected]     DECIMAL (38, 20) NOT NULL,
    [purchaseAmountActual]    DECIMAL (38, 20) NOT NULL,
    [purchaseAmountExpected]  DECIMAL (38, 20) NOT NULL,
    [discountAmount]          DECIMAL (38, 20) NOT NULL,
    [appliesToEntry]          INT              NOT NULL,
    [itemChargeNo]            NVARCHAR (20)    NOT NULL,
    [reasonCode]              NVARCHAR (10)    NOT NULL,
    [dropShipment]            BIT              NOT NULL,
    [journalBatchName]        NVARCHAR (10)    NOT NULL,
    [expectedCost]            BIT              NOT NULL,
    [valuedByAverageCost]     BIT              NOT NULL,
    [partialRevaluation]      BIT              NOT NULL,
    [inventoriable]           BIT              NOT NULL,
    [adjustment]              BIT              NOT NULL,
    [averageCostException]    BIT              NOT NULL,
    [userId]                  NVARCHAR (50)    NOT NULL,
    [salespersPurchCode]      NVARCHAR (20)    NOT NULL,
    [jobNo]                   NVARCHAR (20)    NOT NULL,
    [jobTaskNo]               NVARCHAR (20)    NOT NULL,
    [jobLedgerEntryNo]        INT              NOT NULL,
    [capacityLedgerEntryNo]   INT              NOT NULL,
    [type]                    NVARCHAR (50)    NOT NULL,
    [typeInt]                 INT              NOT NULL,
    [no]                      NVARCHAR (20)    NOT NULL,
    [returnReasonCode]        NVARCHAR (10)    NOT NULL,
    [systemCreatedAt]         DATETIME2 (7)    NULL,
    [systemCreatedBy]         UNIQUEIDENTIFIER NULL,
    [systemModifiedAt]        DATETIME2 (7)    NULL,
    [systemModifiedBy]        UNIQUEIDENTIFIER NULL,
    [PipelineName]            NVARCHAR (200)   NOT NULL,
    [PipelineRunId]           NVARCHAR (100)   NOT NULL,
    [PipelineTriggerTime]     DATETIME2 (7)    NOT NULL,
    CONSTRAINT [PK_ValueEntry] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [entryNo] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_ValueEntry_CompanyId_Item_PostingDate]
    ON [stg_bc_api].[ValueEntry]([CompanyId] ASC, [itemNo] ASC, [postingDate] ASC)
    INCLUDE([entryNo], [variantCode], [locationCode], [itemLedgerEntryType], [itemLedgerEntryTypeInt], [entryType], [entryTypeInt], [valuationDate], [valuedQuantity], [itemLedgerEntryQuantity], [invoicedQuantity], [costAmountActual], [costAmountExpected], [purchaseAmountActual], [salesAmountActual]);


GO

CREATE NONCLUSTERED INDEX [IX_ValueEntry_CompanyId_SystemModifiedAt]
    ON [stg_bc_api].[ValueEntry]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([entryNo], [itemNo], [documentNo], [PipelineRunId]);


GO

CREATE NONCLUSTERED INDEX [IX_ValueEntry_CompanyId_Document]
    ON [stg_bc_api].[ValueEntry]([CompanyId] ASC, [documentNo] ASC, [documentLineNo] ASC)
    INCLUDE([entryNo], [postingDate], [documentType], [documentTypeInt], [itemNo], [itemLedgerEntryNo], [sourceType], [sourceTypeInt], [sourceNo], [costAmountActual], [salesAmountActual], [purchaseAmountActual]);


GO

CREATE NONCLUSTERED INDEX [IX_ValueEntry_CompanyId_ItemLedgerEntryNo]
    ON [stg_bc_api].[ValueEntry]([CompanyId] ASC, [itemLedgerEntryNo] ASC)
    INCLUDE([entryNo], [itemNo], [postingDate], [documentNo], [documentLineNo], [entryType], [entryTypeInt], [costAmountActual], [costAmountExpected], [salesAmountActual], [purchaseAmountActual], [systemModifiedAt]);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_ValueEntry_CompanyId_entryNo]
    ON [stg_bc_api].[ValueEntry]([CompanyId] ASC, [entryNo] ASC);


GO

