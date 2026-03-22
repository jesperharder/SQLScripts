CREATE TABLE [stg_bc_api].[SalesLine] (
    [CompanyId]             INT              NOT NULL,
    [documentType]          NVARCHAR (50)    NULL,
    [documentTypeInt]       INT              NOT NULL,
    [documentNo]            NVARCHAR (20)    NOT NULL,
    [lineNo]                INT              NOT NULL,
    [systemId]              UNIQUEIDENTIFIER NULL,
    [type]                  NVARCHAR (50)    NULL,
    [typeInt]               INT              NULL,
    [no]                    NVARCHAR (20)    NULL,
    [variantCode]           NVARCHAR (10)    NULL,
    [description]           NVARCHAR (100)   NULL,
    [description2]          NVARCHAR (50)    NULL,
    [locationCode]          NVARCHAR (10)    NULL,
    [binCode]               NVARCHAR (20)    NULL,
    [unitOfMeasureCode]     NVARCHAR (10)    NULL,
    [quantity]              DECIMAL (38, 20) NULL,
    [quantityBase]          DECIMAL (38, 20) NULL,
    [unitPrice]             DECIMAL (38, 20) NULL,
    [lineDiscountPercent]   DECIMAL (38, 20) NULL,
    [lineDiscountAmount]    DECIMAL (38, 20) NULL,
    [lineAmount]            DECIMAL (38, 20) NULL,
    [amount]                DECIMAL (38, 20) NULL,
    [amountIncludingVAT]    DECIMAL (38, 20) NULL,
    [genProdPostingGroup]   NVARCHAR (20)    NULL,
    [vatProdPostingGroup]   NVARCHAR (20)    NULL,
    [vatCalculationType]    NVARCHAR (50)    NULL,
    [vatCalculationTypeInt] INT              NULL,
    [vatPercent]            DECIMAL (38, 20) NULL,
    [shipmentDate]          DATE             NULL,
    [applToItemEntry]       INT              NULL,
    [systemCreatedAt]       DATETIME2 (7)    NULL,
    [systemCreatedBy]       NVARCHAR (250)   NULL,
    [systemModifiedAt]      DATETIME2 (7)    NULL,
    [systemModifiedBy]      NVARCHAR (250)   NULL,
    [PipelineName]          NVARCHAR (200)   NULL,
    [PipelineRunId]         NVARCHAR (100)   NULL,
    [PipelineTriggerTime]   DATETIME2 (7)    NULL,
    CONSTRAINT [PK_SalesLine] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [documentTypeInt] ASC, [documentNo] ASC, [lineNo] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_SalesLine_ShipmentDate]
    ON [stg_bc_api].[SalesLine]([CompanyId] ASC, [shipmentDate] ASC)
    INCLUDE([documentTypeInt], [documentNo], [lineNo], [no], [quantity], [amountIncludingVAT], [systemModifiedAt]);


GO

CREATE NONCLUSTERED INDEX [IX_SalesLine_No_Location]
    ON [stg_bc_api].[SalesLine]([CompanyId] ASC, [no] ASC, [locationCode] ASC)
    INCLUDE([documentTypeInt], [documentNo], [lineNo], [type], [typeInt], [quantity], [quantityBase], [lineAmount], [amountIncludingVAT], [shipmentDate], [systemModifiedAt]);


GO

CREATE NONCLUSTERED INDEX [IX_SalesLine_ModifiedAt]
    ON [stg_bc_api].[SalesLine]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([documentTypeInt], [documentNo], [lineNo]);


GO

CREATE NONCLUSTERED INDEX [IX_SalesLine_Document]
    ON [stg_bc_api].[SalesLine]([CompanyId] ASC, [documentTypeInt] ASC, [documentNo] ASC)
    INCLUDE([lineNo], [type], [typeInt], [no], [variantCode], [quantity], [quantityBase], [unitPrice], [lineAmount], [amount], [amountIncludingVAT], [vatProdPostingGroup], [shipmentDate], [systemModifiedAt]);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_SalesLine_Upsert]
    ON [stg_bc_api].[SalesLine]([CompanyId] ASC, [documentTypeInt] ASC, [documentNo] ASC, [lineNo] ASC);


GO

