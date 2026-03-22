CREATE TABLE [dim_v1].[BOM] (
    [BOMKey]               INT            NOT NULL,
    [BOMCompanyID]         INT            NOT NULL,
    [BOMNumber]            NVARCHAR (20)  NOT NULL,
    [BOMName]              NVARCHAR (50)  NOT NULL,
    [BOMNumberName]        NVARCHAR (73)  NOT NULL,
    [BOMUnitOfMeasureCode] NVARCHAR (10)  NOT NULL,
    [BOMLowLevelCode]      INT            NOT NULL,
    [BOMStatus]            NVARCHAR (17)  NOT NULL,
    [BOMHashKey]           NVARCHAR (200) NULL,
    [ADF_BatchId_Insert]   BIGINT         CONSTRAINT [DF_dim_v1_BOM_InsertBacthId] DEFAULT ((0)) NOT NULL,
    [ADF_BatchId_Update]   BIGINT         CONSTRAINT [DF_dim_v1_BOM_UpdateBacthId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_dim_v1_BOM] PRIMARY KEY CLUSTERED ([BOMKey] ASC),
    CONSTRAINT [UQ_dim_v1_BOM] UNIQUE NONCLUSTERED ([BOMCompanyID] ASC, [BOMNumber] ASC)
);


GO

