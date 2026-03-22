CREATE TABLE [stg_bc_api].[PriceListLine] (
    [CompanyId]           INT                NOT NULL,
    [priceListCode]       NVARCHAR (20)      NOT NULL,
    [lineNo]              INT                NOT NULL,
    [status]              NVARCHAR (50)      NULL,
    [statusInt]           INT                NULL,
    [sourceType]          NVARCHAR (50)      NULL,
    [sourceTypeInt]       INT                NULL,
    [assetType]           NVARCHAR (50)      NULL,
    [assetTypeInt]        INT                NULL,
    [sourceNo]            NVARCHAR (20)      NULL,
    [assetNo]             NVARCHAR (20)      NULL,
    [unitOfMeasureCode]   NVARCHAR (10)      NULL,
    [startingDate]        DATE               NULL,
    [endingDate]          DATE               NULL,
    [minimumQuantity]     DECIMAL (18, 5)    NULL,
    [currencyCode]        NVARCHAR (10)      NULL,
    [unitPrice]           DECIMAL (18, 5)    NULL,
    [lineAmount]          DECIMAL (18, 5)    NULL,
    [lineDiscountPct]     DECIMAL (18, 5)    NULL,
    [priceIncludesVAT]    BIT                NULL,
    [systemCreatedAt]     DATETIME2 (7)      NULL,
    [systemCreatedBy]     UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]    DATETIME2 (7)      NULL,
    [systemModifiedBy]    UNIQUEIDENTIFIER   NULL,
    [PipelineName]        NVARCHAR (200)     NULL,
    [PipelineRunId]       UNIQUEIDENTIFIER   NULL,
    [PipelineTriggerTime] DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_PriceListLine] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [priceListCode] ASC, [lineNo] ASC)
);


GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_PriceListLine_UniqueBusinessSignature]
    ON [stg_bc_api].[PriceListLine]([CompanyId] ASC, [priceListCode] ASC, [lineNo] ASC, [sourceTypeInt] ASC, [sourceNo] ASC, [assetTypeInt] ASC, [assetNo] ASC, [unitOfMeasureCode] ASC, [currencyCode] ASC, [startingDate] ASC, [minimumQuantity] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_PriceListLine_SystemModifiedAt]
    ON [stg_bc_api].[PriceListLine]([CompanyId] ASC, [priceListCode] ASC, [lineNo] ASC)
    INCLUDE([systemModifiedAt]);


GO

