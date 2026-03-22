CREATE TABLE [dim_v1].[ReturnReason] (
    [ReturnReasonKey]       INT            NOT NULL,
    [ReturnReasonCompanyID] INT            NOT NULL,
    [ReturnReasonCode]      NVARCHAR (20)  NOT NULL,
    [ReturnReasonName]      NVARCHAR (100) NULL,
    [ReturnReasonCodeName]  NVARCHAR (125) NULL,
    [ReturnReasonHashKey]   NVARCHAR (200) NULL,
    [ADF_BatchId_Insert]    BIGINT         CONSTRAINT [DF_dim_ReturnReason_InsertBacthId] DEFAULT ((0)) NOT NULL,
    [ADF_BatchId_Update]    BIGINT         CONSTRAINT [DF_dim_ReturnReason_UpdateBacthId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_dim_ReturnReason] PRIMARY KEY CLUSTERED ([ReturnReasonKey] ASC),
    CONSTRAINT [UQ_dim_ReturnReason] UNIQUE NONCLUSTERED ([ReturnReasonCompanyID] ASC, [ReturnReasonCode] ASC)
);


GO

