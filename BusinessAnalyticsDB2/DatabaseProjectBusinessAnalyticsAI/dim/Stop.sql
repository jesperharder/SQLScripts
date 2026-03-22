CREATE TABLE [dim].[Stop] (
    [StopKey]            INT            NOT NULL,
    [StopCompanyID]      INT            NOT NULL,
    [StopCode]           NVARCHAR (20)  NOT NULL,
    [StopName]           NVARCHAR (50)  NOT NULL,
    [StopCodeName]       NVARCHAR (73)  NOT NULL,
    [StopHashKey]        NVARCHAR (200) NULL,
    [ADF_BatchId_Insert] BIGINT         CONSTRAINT [DF_dim_Stop_InsertBacthId] DEFAULT ((0)) NOT NULL,
    [ADF_BatchId_Update] BIGINT         CONSTRAINT [DF_dim_Stop_UpdateBacthId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_dim_Stop] PRIMARY KEY CLUSTERED ([StopKey] ASC) WITH (DATA_COMPRESSION = ROW),
    CONSTRAINT [UQ_dim_Stop] UNIQUE NONCLUSTERED ([StopCompanyID] ASC, [StopCode] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

