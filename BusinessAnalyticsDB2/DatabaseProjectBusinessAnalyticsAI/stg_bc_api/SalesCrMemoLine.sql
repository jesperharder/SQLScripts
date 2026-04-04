CREATE TABLE [stg_bc_api].[SalesCrMemoLine] (
    [CompanyId]             INT              NOT NULL,
    [documentNo]            NVARCHAR (20)    NOT NULL,
    [lineNo]                INT              NOT NULL,
    [systemId]              UNIQUEIDENTIFIER NULL,
    [type]                  NVARCHAR (50)    NULL,
    [typeInt]               INT              NULL,
    [vatCalculationType]    NVARCHAR (50)    NULL,
    [vatCalculationTypeInt] INT              NULL,
    [no]                    NVARCHAR (20)    NULL,
    [variantCode]           NVARCHAR (10)    NULL,
    [description]           NVARCHAR (100)   NULL,
    [description2]          NVARCHAR (50)    NULL,
    [yearcodeText]          NVARCHAR (50)    NULL,
    [locationCode]          NVARCHAR (10)    NULL,
    [binCode]               NVARCHAR (20)    NULL,
    [unitOfMeasureCode]     NVARCHAR (10)    NULL,
    [quantity]              DECIMAL (38, 20) NULL,
    [quantityBase]          DECIMAL (38, 20) NULL,
    [unitPrice]             DECIMAL (38, 20) NULL,
    [unitCost]              DECIMAL (38, 20) NULL,
    [unitCostLCY]           DECIMAL (38, 20) NULL,
    [lineDiscountPercent]   DECIMAL (38, 20) NULL,
    [lineDiscountAmount]    DECIMAL (38, 20) NULL,
    [lineAmount]            DECIMAL (38, 20) NULL,
    [amount]                DECIMAL (38, 20) NULL,
    [amountIncludingVAT]    DECIMAL (38, 20) NULL,
    [shortcutDim1Code]      NVARCHAR (20)    NULL,
    [genBusPostingGroup]    NVARCHAR (20)    NULL,
    [genProdPostingGroup]   NVARCHAR (20)    NULL,
    [dimensionSetId]        INT              NULL,
    [vatProdPostingGroup]   NVARCHAR (20)    NULL,
    [vatPercent]            DECIMAL (38, 20) NULL,
    [returnReasonCode]      NVARCHAR (10)    NULL,
    [applToItemEntry]       INT              NULL,
    [systemCreatedAt]       DATETIME2 (7)    NULL,
    [systemCreatedBy]       UNIQUEIDENTIFIER NULL,
    [systemModifiedAt]      DATETIME2 (7)    NULL,
    [systemModifiedBy]      UNIQUEIDENTIFIER NULL,
    [PipelineName]          NVARCHAR (200)   NOT NULL,
    [PipelineRunId]         NVARCHAR (100)   NOT NULL,
    [PipelineTriggerTime]   DATETIME2 (7)    NOT NULL,
    CONSTRAINT [PK_stg_bc_api_SalesCrMemoLine] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [documentNo] ASC, [lineNo] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_stg_bc_api_SalesCrMemoLine_Document]
    ON [stg_bc_api].[SalesCrMemoLine]([CompanyId] ASC, [documentNo] ASC)
    INCLUDE([lineNo], [type], [typeInt], [no], [description], [yearcodeText], [quantity], [unitPrice], [unitCost], [unitCostLCY], [lineAmount], [amount], [amountIncludingVAT], [shortcutDim1Code], [genBusPostingGroup], [genProdPostingGroup], [dimensionSetId], [returnReasonCode]);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_stg_bc_api_SalesCrMemoLine_Upsert]
    ON [stg_bc_api].[SalesCrMemoLine]([CompanyId] ASC, [documentNo] ASC, [lineNo] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_stg_bc_api_SalesCrMemoLine_SystemModifiedAt]
    ON [stg_bc_api].[SalesCrMemoLine]([CompanyId] ASC, [systemModifiedAt] ASC, [documentNo] ASC, [lineNo] ASC)
    INCLUDE([type], [typeInt], [no], [yearcodeText], [quantity], [amount], [unitCost], [unitCostLCY], [shortcutDim1Code], [genBusPostingGroup], [genProdPostingGroup], [dimensionSetId], [returnReasonCode], [PipelineRunId]);


GO

CREATE NONCLUSTERED INDEX [IX_stg_bc_api_SalesCrMemoLine_Item]
    ON [stg_bc_api].[SalesCrMemoLine]([CompanyId] ASC, [no] ASC, [variantCode] ASC)
    INCLUDE([documentNo], [lineNo], [type], [yearcodeText], [quantity], [quantityBase], [locationCode], [unitOfMeasureCode], [amount], [unitCost], [unitCostLCY], [genBusPostingGroup], [genProdPostingGroup], [dimensionSetId]);


GO

