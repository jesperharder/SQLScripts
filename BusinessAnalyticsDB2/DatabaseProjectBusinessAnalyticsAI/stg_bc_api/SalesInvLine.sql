CREATE TABLE [stg_bc_api].[SalesInvLine] (
    [CompanyId]             INT                NOT NULL,
    [documentNo]            NVARCHAR (20)      NOT NULL,
    [lineNo]                INT                NOT NULL,
    [systemId]              UNIQUEIDENTIFIER   NULL,
    [type]                  NVARCHAR (50)      NULL,
    [typeInt]               INT                NULL,
    [no]                    NVARCHAR (20)      NULL,
    [variantCode]           NVARCHAR (10)      NULL,
    [description]           NVARCHAR (100)     NULL,
    [description2]          NVARCHAR (50)      NULL,
    [locationCode]          NVARCHAR (10)      NULL,
    [binCode]               NVARCHAR (20)      NULL,
    [unitOfMeasureCode]     NVARCHAR (10)      NULL,
    [yearCodeText]          NVARCHAR (50)      NULL,
    [quantity]              DECIMAL (18, 5)    NULL,
    [quantityBase]          DECIMAL (18, 5)    NULL,
    [unitPrice]             DECIMAL (18, 5)    NULL,
    [unitCost]              DECIMAL (18, 5)    NULL,
    [unitCostLCY]           DECIMAL (18, 5)    NULL,
    [lineDiscountPercent]   DECIMAL (18, 5)    NULL,
    [lineDiscountAmount]    DECIMAL (18, 5)    NULL,
    [lineAmount]            DECIMAL (18, 5)    NULL,
    [amount]                DECIMAL (18, 5)    NULL,
    [amountIncludingVAT]    DECIMAL (18, 5)    NULL,
    [shortcutDim1Code]      NVARCHAR (20)      NULL,
    [genBusPostingGroup]    NVARCHAR (20)      NULL,
    [genProdPostingGroup]   NVARCHAR (20)      NULL,
    [returnReasonCode]      NVARCHAR (10)      NULL,
    [dimensionSetId]        INT                NULL,
    [vatProdPostingGroup]   NVARCHAR (20)      NULL,
    [vatCalculationType]    NVARCHAR (50)      NULL,
    [vatCalculationTypeInt] INT                NULL,
    [vatPercent]            DECIMAL (18, 5)    NULL,
    [shipmentDate]          DATE               NULL,
    [applToItemEntry]       INT                NULL,
    [systemCreatedAt]       DATETIME2 (7)      NULL,
    [systemCreatedBy]       UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]      DATETIME2 (7)      NULL,
    [systemModifiedBy]      UNIQUEIDENTIFIER   NULL,
    [PipelineName]          NVARCHAR (200)     NULL,
    [PipelineRunId]         UNIQUEIDENTIFIER   NULL,
    [PipelineTriggerTime]   DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_SalesInvLine] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [documentNo] ASC, [lineNo] ASC)
);

GO

CREATE NONCLUSTERED INDEX [IX_SalesInvLine_Document]
    ON [stg_bc_api].[SalesInvLine]([CompanyId] ASC, [documentNo] ASC)
    INCLUDE([lineNo], [typeInt], [no], [variantCode], [locationCode], [quantity], [amount], [amountIncludingVAT], [shipmentDate], [yearCodeText], [systemModifiedAt], [unitCost], [unitCostLCY], [dimensionSetId]);

GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_SalesInvLine_Upsert]
    ON [stg_bc_api].[SalesInvLine]([CompanyId] ASC, [documentNo] ASC, [lineNo] ASC);

GO

CREATE NONCLUSTERED INDEX [IX_SalesInvLine_Item]
    ON [stg_bc_api].[SalesInvLine]([CompanyId] ASC, [no] ASC, [variantCode] ASC)
    INCLUDE([documentNo], [lineNo], [typeInt], [locationCode], [quantity], [amount], [amountIncludingVAT], [yearCodeText], [systemModifiedAt], [unitCost], [unitCostLCY], [genBusPostingGroup], [genProdPostingGroup]);

GO

CREATE NONCLUSTERED INDEX [IX_SalesInvLine_SystemModifiedAt]
    ON [stg_bc_api].[SalesInvLine]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([documentNo], [lineNo], [typeInt], [no], [quantity], [amount], [amountIncludingVAT], [yearCodeText], [unitCost], [unitCostLCY], [returnReasonCode], [dimensionSetId]);

GO
