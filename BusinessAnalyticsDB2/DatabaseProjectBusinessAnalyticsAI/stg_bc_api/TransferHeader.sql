CREATE TABLE [stg_bc_api].[TransferHeader] (
    [CompanyId]                INT                NOT NULL,
    [no]                       NVARCHAR (20)      NOT NULL,
    [status]                   NVARCHAR (50)      NULL,
    [statusInt]                INT                NULL,
    [transferFromCode]         NVARCHAR (10)      NULL,
    [transferFromName]         NVARCHAR (100)     NULL,
    [transferToCode]           NVARCHAR (10)      NULL,
    [transferToName]           NVARCHAR (100)     NULL,
    [inTransitCode]            NVARCHAR (10)      NULL,
    [directTransfer]           BIT                NULL,
    [postingDate]              DATE               NULL,
    [shipmentDate]             DATE               NULL,
    [receiptDate]              DATE               NULL,
    [shipmentMethodCode]       NVARCHAR (10)      NULL,
    [shippingAgentCode]        NVARCHAR (10)      NULL,
    [shippingAgentServiceCode] NVARCHAR (10)      NULL,
    [shippingTime]             NVARCHAR (50)      NULL,
    [outboundWhseHandlingTime] NVARCHAR (50)      NULL,
    [inboundWhseHandlingTime]  NVARCHAR (50)      NULL,
    [externalDocumentNo]       NVARCHAR (35)      NULL,
    [assignedUserId]           NVARCHAR (50)      NULL,
    [shortcutDim1Code]         NVARCHAR (20)      NULL,
    [shortcutDim2Code]         NVARCHAR (20)      NULL,
    [completelyShipped]        BIT                NULL,
    [completelyReceived]       BIT                NULL,
    [systemId]                 UNIQUEIDENTIFIER   NULL,
    [systemCreatedAt]          DATETIME2 (7)      NULL,
    [systemCreatedBy]          UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]         DATETIME2 (7)      NULL,
    [systemModifiedBy]         UNIQUEIDENTIFIER   NULL,
    [PipelineName]             NVARCHAR (200)     NULL,
    [PipelineRunId]            UNIQUEIDENTIFIER   NULL,
    [PipelineTriggerTime]      DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_TransferHeader] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [no] ASC)
);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_TransferHeader_Upsert]
    ON [stg_bc_api].[TransferHeader]([CompanyId] ASC, [no] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_TransferHeader_SystemModifiedAt]
    ON [stg_bc_api].[TransferHeader]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([no], [statusInt], [transferFromCode], [transferToCode], [shipmentDate], [receiptDate], [directTransfer]);


GO

CREATE NONCLUSTERED INDEX [IX_TransferHeader_Status]
    ON [stg_bc_api].[TransferHeader]([CompanyId] ASC, [statusInt] ASC, [shipmentDate] ASC)
    INCLUDE([no], [transferFromCode], [transferToCode], [receiptDate], [directTransfer], [completelyShipped], [completelyReceived]);


GO

CREATE NONCLUSTERED INDEX [IX_TransferHeader_Locations]
    ON [stg_bc_api].[TransferHeader]([CompanyId] ASC, [transferFromCode] ASC, [transferToCode] ASC, [shipmentDate] ASC)
    INCLUDE([no], [statusInt], [receiptDate], [inTransitCode], [directTransfer], [systemModifiedAt]);


GO

