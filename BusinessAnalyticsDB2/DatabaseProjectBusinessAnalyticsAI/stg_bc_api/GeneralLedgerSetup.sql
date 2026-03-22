CREATE TABLE [stg_bc_api].[GeneralLedgerSetup] (
    [CompanyId]                    INT                NOT NULL,
    [primaryKey]                   NVARCHAR (10)      NOT NULL,
    [allowPostingFrom]             DATE               NULL,
    [allowPostingTo]               DATE               NULL,
    [lcyCode]                      NVARCHAR (10)      NULL,
    [additionalReportingCurrency]  NVARCHAR (10)      NULL,
    [amountRoundingPrecision]      DECIMAL (38, 20)   NULL,
    [unitAmountRoundingPrecision]  DECIMAL (38, 20)   NULL,
    [invRoundingPrecisionLCY]      DECIMAL (38, 20)   NULL,
    [invRoundingTypeLCY]           NVARCHAR (50)      NULL,
    [invRoundingTypeLCYInt]        INT                NULL,
    [vatRoundingType]              NVARCHAR (50)      NULL,
    [vatRoundingTypeInt]           INT                NULL,
    [globalDimension1Code]         NVARCHAR (20)      NULL,
    [globalDimension2Code]         NVARCHAR (20)      NULL,
    [shortcutDim1Code]             NVARCHAR (20)      NULL,
    [shortcutDim2Code]             NVARCHAR (20)      NULL,
    [shortcutDim3Code]             NVARCHAR (20)      NULL,
    [shortcutDim4Code]             NVARCHAR (20)      NULL,
    [shortcutDim5Code]             NVARCHAR (20)      NULL,
    [shortcutDim6Code]             NVARCHAR (20)      NULL,
    [shortcutDim7Code]             NVARCHAR (20)      NULL,
    [shortcutDim8Code]             NVARCHAR (20)      NULL,
    [unrealizedVAT]                BIT                NULL,
    [prepaymentUnrealizedVAT]      BIT                NULL,
    [vatTolerancePct]              DECIMAL (38, 20)   NULL,
    [maxVATDiffAllowed]            DECIMAL (38, 20)   NULL,
    [paymentTolerancePct]          DECIMAL (38, 20)   NULL,
    [maxPaymentToleranceAmt]       DECIMAL (38, 20)   NULL,
    [registerTime]                 BIT                NULL,
    [postWithJobQueue]             BIT                NULL,
    [postAndPrintWithJobQueue]     BIT                NULL,
    [notifyOnSuccess]              BIT                NULL,
    [summarizeGLEntries]           BIT                NULL,
    [localAddressFormat]           NVARCHAR (50)      NULL,
    [localAddressFormatInt]        INT                NULL,
    [localContAddrFormat]          NVARCHAR (50)      NULL,
    [localContAddrFormatInt]       INT                NULL,
    [showAmounts]                  NVARCHAR (50)      NULL,
    [showAmountsInt]               INT                NULL,
    [markCrMemosAsCorrections]     BIT                NULL,
    [sepaNonEuroExport]            BIT                NULL,
    [sepaExportWithoutBankAccData] BIT                NULL,
    [systemId]                     UNIQUEIDENTIFIER   NULL,
    [systemCreatedAt]              DATETIMEOFFSET (7) NULL,
    [systemCreatedBy]              UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]             DATETIMEOFFSET (7) NULL,
    [systemModifiedBy]             UNIQUEIDENTIFIER   NULL,
    [PipelineName]                 NVARCHAR (200)     NULL,
    [PipelineRunId]                NVARCHAR (100)     NULL,
    [PipelineTriggerTime]          DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_GeneralLedgerSetup] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [primaryKey] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_GeneralLedgerSetup_Company_SystemModified]
    ON [stg_bc_api].[GeneralLedgerSetup]([CompanyId] ASC, [systemModifiedAt] ASC);


GO

