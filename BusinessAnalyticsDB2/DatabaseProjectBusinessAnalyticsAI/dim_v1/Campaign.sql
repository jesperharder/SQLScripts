CREATE TABLE [dim_v1].[Campaign] (
    [CampaignKey]             INT            NOT NULL,
    [CampaignCompanyID]       INT            NOT NULL,
    [CampaignNo]              NVARCHAR (50)  NOT NULL,
    [CampaignDescription]     NVARCHAR (255) NULL,
    [CampaignStartingDate]    DATE           NULL,
    [CampaignEndingDate]      DATE           NULL,
    [CampaignPeriod]          NVARCHAR (50)  NULL,
    [CampaignSalespersonCode] NVARCHAR (50)  NULL,
    [CampaignStatusCode]      NVARCHAR (50)  NULL,
    [SourceDB]                NVARCHAR (50)  NULL,
    [CampaignHashKey]         NVARCHAR (200) NULL,
    [ADF_BatchId_Insert]      BIGINT         DEFAULT ((0)) NOT NULL,
    [ADF_BatchId_Update]      BIGINT         DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_dim_Campaign] PRIMARY KEY CLUSTERED ([CampaignKey] ASC),
    CONSTRAINT [UQ_dim_Campaign] UNIQUE NONCLUSTERED ([CampaignCompanyID] ASC, [CampaignNo] ASC)
);


GO

