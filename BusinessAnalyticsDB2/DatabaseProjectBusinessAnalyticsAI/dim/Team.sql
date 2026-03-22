CREATE TABLE [dim].[Team] (
    [TeamKey]            INT            NOT NULL,
    [TeamCode]           NVARCHAR (20)  NOT NULL,
    [TeamName]           NVARCHAR (100) NULL,
    [TeamCodeName]       NVARCHAR (125) NULL,
    [TeamPersonCode]     NVARCHAR (20)  NOT NULL,
    [TeamPersonName]     NVARCHAR (100) NULL,
    [TeamPersonCodeName] NVARCHAR (125) NULL,
    [TeamCompanyID]      INT            NOT NULL,
    [TeamHashKey]        NVARCHAR (200) NULL,
    [ADF_BatchId_Insert] BIGINT         CONSTRAINT [DF_dim_Team_InsertBacthId] DEFAULT ((0)) NOT NULL,
    [ADF_BatchId_Update] BIGINT         CONSTRAINT [DF_dim_Team_UpdateBacthId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_dim_Team] PRIMARY KEY CLUSTERED ([TeamKey] ASC) WITH (DATA_COMPRESSION = ROW),
    CONSTRAINT [UQ_dim_Team] UNIQUE NONCLUSTERED ([TeamCompanyID] ASC, [TeamCode] ASC, [TeamPersonCode] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

