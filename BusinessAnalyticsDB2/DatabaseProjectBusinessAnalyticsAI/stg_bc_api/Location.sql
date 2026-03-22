CREATE TABLE [stg_bc_api].[Location] (
    [CompanyId]                INT                NOT NULL,
    [code]                     NVARCHAR (10)      NOT NULL,
    [name]                     NVARCHAR (100)     NULL,
    [address]                  NVARCHAR (100)     NULL,
    [address2]                 NVARCHAR (50)      NULL,
    [city]                     NVARCHAR (30)      NULL,
    [postCode]                 NVARCHAR (20)      NULL,
    [county]                   NVARCHAR (30)      NULL,
    [countryRegionCode]        NVARCHAR (10)      NULL,
    [contact]                  NVARCHAR (100)     NULL,
    [phoneNo]                  NVARCHAR (30)      NULL,
    [email]                    NVARCHAR (80)      NULL,
    [useAsInTransit]           BIT                NULL,
    [requireReceive]           BIT                NULL,
    [requireShipment]          BIT                NULL,
    [requirePutAway]           BIT                NULL,
    [requirePick]              BIT                NULL,
    [binMandatory]             BIT                NULL,
    [directedPutAwayPick]      BIT                NULL,
    [useCrossDocking]          BIT                NULL,
    [inboundWhseHandlingTime]  NVARCHAR (32)      NULL,
    [outboundWhseHandlingTime] NVARCHAR (32)      NULL,
    [crossDockDueDateCalc]     NVARCHAR (32)      NULL,
    [receiptBinCode]           NVARCHAR (20)      NULL,
    [shipmentBinCode]          NVARCHAR (20)      NULL,
    [adjustmentBinCode]        NVARCHAR (20)      NULL,
    [toProdBinCode]            NVARCHAR (20)      NULL,
    [fromProdBinCode]          NVARCHAR (20)      NULL,
    [systemId]                 UNIQUEIDENTIFIER   NULL,
    [systemCreatedAt]          DATETIMEOFFSET (7) NULL,
    [systemCreatedBy]          UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]         DATETIMEOFFSET (7) NULL,
    [systemModifiedBy]         UNIQUEIDENTIFIER   NULL,
    [PipelineName]             NVARCHAR (200)     NULL,
    [PipelineRunId]            UNIQUEIDENTIFIER   NULL,
    [PipelineTriggerTime]      DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_stg_Location] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [code] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_stg_Location_Country]
    ON [stg_bc_api].[Location]([CompanyId] ASC, [countryRegionCode] ASC)
    INCLUDE([code], [name]);


GO

CREATE NONCLUSTERED INDEX [IX_stg_Location_Watermark]
    ON [stg_bc_api].[Location]([CompanyId] ASC, [systemModifiedAt] ASC);


GO

