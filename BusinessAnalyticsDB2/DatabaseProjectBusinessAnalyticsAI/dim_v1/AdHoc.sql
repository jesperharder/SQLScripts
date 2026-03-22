CREATE TABLE [dim_v1].[AdHoc] (
    [AdHocKey]           INT            NOT NULL,
    [CompanyID]          INT            NOT NULL,
    [AdHocCode]          NVARCHAR (20)  NOT NULL,
    [AdHocName]          NVARCHAR (100) NULL,
    [AdHocCodeName]      NVARCHAR (125) NULL,
    [AdHocHashKey]       NVARCHAR (200) NULL,
    [Dimension Code]     NVARCHAR (20)  NOT NULL,
    [ADF_BatchId_Insert] BIGINT         CONSTRAINT [DF_dim_AdHoc_InsertBacthId] DEFAULT ((0)) NOT NULL,
    [ADF_BatchId_Update] BIGINT         CONSTRAINT [DF_dim_AdHoc_UpdateBacthId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_dim_AdHoc] PRIMARY KEY CLUSTERED ([AdHocKey] ASC),
    CONSTRAINT [UQ_dim_AdHoc] UNIQUE NONCLUSTERED ([CompanyID] ASC, [Dimension Code] ASC, [AdHocCode] ASC)
);


GO

