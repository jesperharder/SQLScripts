CREATE TABLE [stg_bc_api].[FixedAsset] (
    [CompanyId]             INT                NOT NULL,
    [no]                    NVARCHAR (20)      NOT NULL,
    [description]           NVARCHAR (100)     NULL,
    [description2]          NVARCHAR (100)     NULL,
    [searchDescription]     NVARCHAR (100)     NULL,
    [faClassCode]           NVARCHAR (20)      NULL,
    [faSubclassCode]        NVARCHAR (20)      NULL,
    [locationCode]          NVARCHAR (10)      NULL,
    [faLocationCode]        NVARCHAR (20)      NULL,
    [faPostingGroup]        NVARCHAR (20)      NULL,
    [vendorNo]              NVARCHAR (20)      NULL,
    [mainAssetComponent]    NVARCHAR (50)      NULL,
    [mainAssetComponentInt] INT                NULL,
    [componentOfMainAsset]  NVARCHAR (20)      NULL,
    [budgetedAsset]         BIT                NULL,
    [warrantyDate]          DATE               NULL,
    [responsibleEmployee]   NVARCHAR (20)      NULL,
    [serialNo]              NVARCHAR (50)      NULL,
    [maintenanceVendorNo]   NVARCHAR (20)      NULL,
    [underMaintenance]      BIT                NULL,
    [nextServiceDate]       DATE               NULL,
    [inactive]              BIT                NULL,
    [blocked]               BIT                NULL,
    [acquired]              BIT                NULL,
    [insured]               BIT                NULL,
    [comment]               BIT                NULL,
    [globalDimension1Code]  NVARCHAR (20)      NULL,
    [globalDimension2Code]  NVARCHAR (20)      NULL,
    [lastDateModified]      DATE               NULL,
    [noSeries]              NVARCHAR (20)      NULL,
    [systemId]              UNIQUEIDENTIFIER   NULL,
    [systemCreatedAt]       DATETIMEOFFSET (7) NULL,
    [systemCreatedBy]       UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]      DATETIMEOFFSET (7) NULL,
    [systemModifiedBy]      UNIQUEIDENTIFIER   NULL,
    [PipelineName]          NVARCHAR (200)     NULL,
    [PipelineRunId]         NVARCHAR (100)     NULL,
    [PipelineTriggerTime]   DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_FixedAsset] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [no] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_FixedAsset_Company_SystemModified]
    ON [stg_bc_api].[FixedAsset]([CompanyId] ASC, [systemModifiedAt] ASC);


GO

