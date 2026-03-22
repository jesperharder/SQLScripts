CREATE TABLE [dim].[Location] (
    [LocationKey]        INT            NOT NULL,
    [CompanyID]          INT            NOT NULL,
    [LocationCode]       NVARCHAR (20)  NOT NULL,
    [LocationName]       NVARCHAR (100) NULL,
    [LocationCodeName]   NVARCHAR (123) NULL,
    [LocationCountry]    NVARCHAR (125) NULL,
    [LocationHashKey]    NVARCHAR (200) NULL,
    [ADF_BatchId_Insert] BIGINT         CONSTRAINT [DF_dim_Location_InsertBacthId] DEFAULT ((0)) NOT NULL,
    [ADF_BatchId_Update] BIGINT         CONSTRAINT [DF_dim_Location_UpdateBacthId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_dim_Location] PRIMARY KEY NONCLUSTERED ([LocationKey] ASC) WITH (DATA_COMPRESSION = ROW),
    CONSTRAINT [UQ_dim_Location] UNIQUE CLUSTERED ([CompanyID] ASC, [LocationCode] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

