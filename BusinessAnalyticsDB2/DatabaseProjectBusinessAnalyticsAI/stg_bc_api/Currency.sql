CREATE TABLE [stg_bc_api].[Currency] (
    [CompanyId]                   INT                NOT NULL,
    [code]                        NVARCHAR (10)      NOT NULL,
    [description]                 NVARCHAR (50)      NULL,
    [isoCode]                     NVARCHAR (10)      NULL,
    [amountRoundingPrecision]     DECIMAL (38, 20)   NULL,
    [unitAmountRoundingPrecision] DECIMAL (38, 20)   NULL,
    [invoiceRoundingPrecision]    DECIMAL (38, 20)   NULL,
    [invoiceRoundingType]         NVARCHAR (50)      NULL,
    [invoiceRoundingTypeInt]      INT                NULL,
    [systemId]                    UNIQUEIDENTIFIER   NULL,
    [systemCreatedAt]             DATETIMEOFFSET (7) NULL,
    [systemCreatedBy]             UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]            DATETIMEOFFSET (7) NULL,
    [systemModifiedBy]            UNIQUEIDENTIFIER   NULL,
    [PipelineName]                NVARCHAR (200)     NULL,
    [PipelineRunId]               NVARCHAR (100)     NULL,
    [PipelineTriggerTime]         DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_Currency] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [code] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_Currency_Company_Code]
    ON [stg_bc_api].[Currency]([CompanyId] ASC, [code] ASC);


GO

