CREATE TABLE [stg_bc_api].[WorkCenter] (
    [CompanyId]                  INT              NOT NULL,
    [no]                         NVARCHAR (20)    NOT NULL,
    [name]                       NVARCHAR (100)   NULL,
    [searchName]                 NVARCHAR (100)   NULL,
    [name2]                      NVARCHAR (50)    NULL,
    [address]                    NVARCHAR (100)   NULL,
    [address2]                   NVARCHAR (50)    NULL,
    [city]                       NVARCHAR (30)    NULL,
    [postCode]                   NVARCHAR (20)    NULL,
    [county]                     NVARCHAR (30)    NULL,
    [countryRegionCode]          NVARCHAR (10)    NULL,
    [alternateWorkCenter]        NVARCHAR (20)    NULL,
    [workCenterGroupCode]        NVARCHAR (10)    NULL,
    [globalDimension1Code]       NVARCHAR (20)    NULL,
    [globalDimension2Code]       NVARCHAR (20)    NULL,
    [subcontractorNo]            NVARCHAR (20)    NULL,
    [noSeries]                   NVARCHAR (20)    NULL,
    [genProdPostingGroup]        NVARCHAR (20)    NULL,
    [directUnitCost]             DECIMAL (38, 20) NULL,
    [indirectCostPct]            DECIMAL (38, 20) NULL,
    [unitCost]                   DECIMAL (38, 20) NULL,
    [overheadRate]               DECIMAL (38, 20) NULL,
    [queueTime]                  DECIMAL (38, 20) NULL,
    [queueTimeUnitOfMeasureCode] NVARCHAR (10)    NULL,
    [unitOfMeasureCode]          NVARCHAR (10)    NULL,
    [capacity]                   DECIMAL (38, 20) NULL,
    [efficiency]                 DECIMAL (38, 20) NULL,
    [maximumEfficiency]          DECIMAL (38, 20) NULL,
    [minimumEfficiency]          DECIMAL (38, 20) NULL,
    [calendarRoundingPrecision]  DECIMAL (38, 20) NULL,
    [simulationType]             NVARCHAR (50)    NULL,
    [simulationTypeInt]          INT              NULL,
    [unitCostCalculation]        NVARCHAR (50)    NULL,
    [unitCostCalculationInt]     INT              NULL,
    [flushingMethod]             NVARCHAR (50)    NULL,
    [flushingMethodInt]          INT              NULL,
    [shopCalendarCode]           NVARCHAR (10)    NULL,
    [blocked]                    BIT              NULL,
    [specificUnitCost]           BIT              NULL,
    [consolidatedCalendar]       BIT              NULL,
    [lastDateModified]           DATE             NULL,
    [locationCode]               NVARCHAR (10)    NULL,
    [openShopFloorBinCode]       NVARCHAR (20)    NULL,
    [toProductionBinCode]        NVARCHAR (20)    NULL,
    [fromProductionBinCode]      NVARCHAR (20)    NULL,
    [systemId]                   UNIQUEIDENTIFIER NULL,
    [systemCreatedAt]            DATETIME2 (7)    NULL,
    [systemCreatedBy]            UNIQUEIDENTIFIER NULL,
    [systemModifiedAt]           DATETIME2 (7)    NULL,
    [systemModifiedBy]           UNIQUEIDENTIFIER NULL,
    [PipelineName]               NVARCHAR (200)   NOT NULL,
    [PipelineRunId]              NVARCHAR (100)   NOT NULL,
    [PipelineTriggerTime]        DATETIME2 (7)    NOT NULL,
    CONSTRAINT [PK_stg_bc_api_WorkCenter] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [no] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_stg_bc_api_WorkCenter_Lookup_Location]
    ON [stg_bc_api].[WorkCenter]([CompanyId] ASC, [locationCode] ASC, [no] ASC)
    INCLUDE([name], [workCenterGroupCode], [blocked], [openShopFloorBinCode], [toProductionBinCode], [fromProductionBinCode]);


GO

CREATE NONCLUSTERED INDEX [IX_stg_bc_api_WorkCenter_SystemModifiedAt]
    ON [stg_bc_api].[WorkCenter]([CompanyId] ASC, [systemModifiedAt] ASC, [no] ASC)
    INCLUDE([name], [workCenterGroupCode], [locationCode], [blocked], [PipelineRunId]);


GO

CREATE NONCLUSTERED INDEX [IX_stg_bc_api_WorkCenter_Lookup_Group]
    ON [stg_bc_api].[WorkCenter]([CompanyId] ASC, [workCenterGroupCode] ASC, [no] ASC)
    INCLUDE([name], [locationCode], [shopCalendarCode], [blocked], [unitOfMeasureCode], [capacity], [efficiency]);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_stg_bc_api_WorkCenter_Upsert]
    ON [stg_bc_api].[WorkCenter]([CompanyId] ASC, [no] ASC);


GO

