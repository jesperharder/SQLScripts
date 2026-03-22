CREATE TABLE [stg_bc_api].[CustomerIndustryGroups] (
    [CompanyId]           INT              NOT NULL,
    [customerNo]          NVARCHAR (20)    NOT NULL,
    [industryGroupCode]   NVARCHAR (20)    NOT NULL,
    [contactNo]           NVARCHAR (20)    NULL,
    [customerName]        NVARCHAR (100)   NULL,
    [industryGroupName]   NVARCHAR (100)   NULL,
    [relationCode]        NVARCHAR (20)    NULL,
    [systemId]            UNIQUEIDENTIFIER NULL,
    [systemCreatedAt]     DATETIME2 (7)    NULL,
    [systemCreatedBy]     UNIQUEIDENTIFIER NULL,
    [systemModifiedAt]    DATETIME2 (7)    NULL,
    [systemModifiedBy]    UNIQUEIDENTIFIER NULL,
    [PipelineName]        NVARCHAR (200)   NOT NULL,
    [PipelineRunId]       NVARCHAR (100)   NOT NULL,
    [PipelineTriggerTime] DATETIME2 (7)    NOT NULL,
    CONSTRAINT [PK_stg_bc_api_CustomerIndustryGroups] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [customerNo] ASC, [industryGroupCode] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_stg_bc_api_CustomerIndustryGroups_SystemModifiedAt]
    ON [stg_bc_api].[CustomerIndustryGroups]([CompanyId] ASC, [systemModifiedAt] ASC)
    INCLUDE([customerNo], [industryGroupCode], [contactNo], [customerName], [industryGroupName]);


GO

CREATE NONCLUSTERED INDEX [IX_stg_bc_api_CustomerIndustryGroups_IndustryGroup]
    ON [stg_bc_api].[CustomerIndustryGroups]([CompanyId] ASC, [industryGroupCode] ASC)
    INCLUDE([customerNo], [contactNo], [customerName], [industryGroupName], [relationCode], [systemModifiedAt]);


GO

CREATE NONCLUSTERED INDEX [IX_stg_bc_api_CustomerIndustryGroups_Customer]
    ON [stg_bc_api].[CustomerIndustryGroups]([CompanyId] ASC, [customerNo] ASC)
    INCLUDE([industryGroupCode], [contactNo], [customerName], [industryGroupName], [relationCode], [systemModifiedAt]);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_stg_bc_api_CustomerIndustryGroups_Upsert]
    ON [stg_bc_api].[CustomerIndustryGroups]([CompanyId] ASC, [customerNo] ASC, [industryGroupCode] ASC);


GO

