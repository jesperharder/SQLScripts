CREATE TABLE [dim].[Maintainance] (
    [MaintainanceKey]      INT            NOT NULL,
    [MaintainanceCode]     NVARCHAR (20)  NOT NULL,
    [MaintainanceName]     NVARCHAR (100) NULL,
    [MaintainanceCodeName] NVARCHAR (125) NULL,
    [MaintainanceHashKey]  NVARCHAR (200) NULL,
    [Dimension Code]       NVARCHAR (20)  NOT NULL,
    [CompanyID]            INT            NOT NULL,
    [ADF_BatchId_Insert]   BIGINT         CONSTRAINT [DF_dim_Maintainance_InsertBacthId] DEFAULT ((0)) NOT NULL,
    [ADF_BatchId_Update]   BIGINT         CONSTRAINT [DF_dim_Maintainance_UpdateBacthId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_dim_Maintainance] PRIMARY KEY CLUSTERED ([MaintainanceKey] ASC) WITH (DATA_COMPRESSION = ROW),
    CONSTRAINT [UQ_dim_Maintainance] UNIQUE NONCLUSTERED ([CompanyID] ASC, [Dimension Code] ASC, [MaintainanceCode] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

