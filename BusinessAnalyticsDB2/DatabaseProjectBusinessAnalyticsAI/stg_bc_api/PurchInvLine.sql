CREATE TABLE [stg_bc_api].[PurchInvLine] (
    [CompanyId]             INT              NOT NULL,
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
    [directUnitCost]        DECIMAL (38, 20) NULL,
    [lineDiscountPercent]   DECIMAL (38, 20) NULL,
    [lineDiscountAmount]    DECIMAL (38, 20) NULL,
    [lineAmount]            DECIMAL (38, 20) NULL,
    [amount]                DECIMAL (38, 20) NULL,
    [amountIncludingVAT]    DECIMAL (38, 20) NULL,
    [genBusPostingGroup]    NVARCHAR (20)    NULL,
    [genProdPostingGroup]   NVARCHAR (20)    NULL,
    [vatProdPostingGroup]   NVARCHAR (20)    NULL,
    [vatCalculationType]    NVARCHAR (50)    NULL,
    [vatCalculationTypeInt] INT              NULL,
    [vatPercent]            DECIMAL (38, 20) NULL,
    [applToItemEntry]       INT              NULL,
    [systemCreatedAt]       DATETIME2 (7)    NULL,
    [systemCreatedBy]       NVARCHAR (250)   NULL,
    [systemModifiedAt]      DATETIME2 (7)    NULL,
    [systemModifiedBy]      NVARCHAR (250)   NULL,
    [PipelineName]          NVARCHAR (200)   NULL,
    [PipelineRunId]         NVARCHAR (100)   NULL,
    [PipelineTriggerTime]   DATETIME2 (7)    NULL,
    CONSTRAINT [PK_PurchInvLine] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [documentNo] ASC, [lineNo] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_PurchInvLine_ModifiedAt]
    ON [stg_bc_api].[PurchInvLine]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([documentNo], [lineNo]);


GO

CREATE NONCLUSTERED INDEX [IX_PurchInvLine_No_Location]
    ON [stg_bc_api].[PurchInvLine]([CompanyId] ASC, [no] ASC, [locationCode] ASC)
    INCLUDE([documentNo], [lineNo], [type], [typeInt], [quantity], [quantityBase], [lineAmount], [amountIncludingVAT], [systemModifiedAt]);


GO

CREATE NONCLUSTERED INDEX [IX_PurchInvLine_Document]
    ON [stg_bc_api].[PurchInvLine]([CompanyId] ASC, [documentNo] ASC)
    INCLUDE([lineNo], [type], [typeInt], [no], [quantity], [quantityBase], [lineAmount], [amount], [amountIncludingVAT], [vatProdPostingGroup], [systemModifiedAt]);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_PurchInvLine_Upsert]
    ON [stg_bc_api].[PurchInvLine]([CompanyId] ASC, [documentNo] ASC, [lineNo] ASC);


GO

