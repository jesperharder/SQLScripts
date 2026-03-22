CREATE TABLE [dim].[YearCode] (
    [YearCodeKey]        INT            NOT NULL,
    [YearCodeCompanyID]  INT            NOT NULL,
    [YearCodeText]       NVARCHAR (30)  NOT NULL,
    [YearCodeFromDate]   NVARCHAR (30)  NOT NULL,
    [YearCodeToDate]     NVARCHAR (30)  NOT NULL,
    [YearCodeHashKey]    NVARCHAR (200) NULL,
    [ADF_BatchId_Insert] BIGINT         CONSTRAINT [DF_dim_YearCode_InsertBacthId] DEFAULT ((0)) NOT NULL,
    [ADF_BatchId_Update] BIGINT         CONSTRAINT [DF_dim_YearCode_UpdateBacthId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_dim_YearCode] PRIMARY KEY CLUSTERED ([YearCodeKey] ASC),
    CONSTRAINT [UQ_dim_YearCode] UNIQUE NONCLUSTERED ([YearCodeCompanyID] ASC, [YearCodeText] ASC)
);


GO

