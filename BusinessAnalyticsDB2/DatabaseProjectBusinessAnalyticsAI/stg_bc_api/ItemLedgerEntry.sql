CREATE TABLE [stg_bc_api].[ItemLedgerEntry] (
    [CompanyId]            INT                NOT NULL,
    [entryNo]              INT                NOT NULL,
    [systemId]             UNIQUEIDENTIFIER   NULL,
    [itemNo]               NVARCHAR (20)      NULL,
    [itemDescription]      NVARCHAR (100)     NULL,
    [postingDate]          DATE               NULL,
    [documentType]         NVARCHAR (50)      NULL,
    [documentTypeInt]      INT                NULL,
    [documentNo]           NVARCHAR (20)      NULL,
    [entryType]            NVARCHAR (50)      NULL,
    [entryTypeInt]         INT                NULL,
    [sourceType]           NVARCHAR (50)      NULL,
    [sourceTypeInt]        INT                NULL,
    [sourceNo]             NVARCHAR (20)      NULL,
    [sourceName]           NVARCHAR (100)     NULL,
    [locationCode]         NVARCHAR (10)      NULL,
    [locationName]         NVARCHAR (100)     NULL,
    [variantCode]          NVARCHAR (10)      NULL,
    [quantity]             DECIMAL (38, 20)   NULL,
    [remainingQuantity]    DECIMAL (38, 20)   NULL,
    [invoicedQuantity]     DECIMAL (38, 20)   NULL,
    [open]                 BIT                NULL,
    [positive]             BIT                NULL,
    [costAmountExpected]   DECIMAL (38, 20)   NULL,
    [costAmountActual]     DECIMAL (38, 20)   NULL,
    [lotNo]                NVARCHAR (50)      NULL,
    [serialNo]             NVARCHAR (50)      NULL,
    [itemTracking]         NVARCHAR (50)      NULL,
    [itemTrackingInt]      INT                NULL,
    [globalDimension1Code] NVARCHAR (20)      NULL,
    [globalDimension2Code] NVARCHAR (20)      NULL,
    [dimensionSetId]       INT                NULL,
    [orderType]            NVARCHAR (50)      NULL,
    [orderTypeInt]         INT                NULL,
    [orderNo]              NVARCHAR (20)      NULL,
    [orderLineNo]          INT                NULL,
    [appliesToEntry]       INT                NULL,
    [systemCreatedAt]      DATETIME2 (7)      NULL,
    [systemCreatedBy]      UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]     DATETIME2 (7)      NULL,
    [systemModifiedBy]     UNIQUEIDENTIFIER   NULL,
    [PipelineName]         NVARCHAR (200)     NULL,
    [PipelineRunId]        UNIQUEIDENTIFIER   NULL,
    [PipelineTriggerTime]  DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_ItemLedgerEntry] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [entryNo] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_ItemLedgerEntry_Company_DimensionSetId]
    ON [stg_bc_api].[ItemLedgerEntry]([CompanyId] ASC, [dimensionSetId] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_ItemLedgerEntry_Company_SystemModifiedAt]
    ON [stg_bc_api].[ItemLedgerEntry]([CompanyId] ASC, [systemModifiedAt] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_ItemLedgerEntry_Company_Item_PostingDate]
    ON [stg_bc_api].[ItemLedgerEntry]([CompanyId] ASC, [itemNo] ASC, [postingDate] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_ItemLedgerEntry_Company_Location_PostingDate]
    ON [stg_bc_api].[ItemLedgerEntry]([CompanyId] ASC, [locationCode] ASC, [postingDate] ASC);


GO

