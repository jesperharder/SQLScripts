CREATE TABLE [dim].[Department] (
    [DepartmentKey]      INT            NOT NULL,
    [CompanyID]          INT            NOT NULL,
    [DepartmentCode]     NVARCHAR (20)  NOT NULL,
    [DepartmentName]     NVARCHAR (100) NULL,
    [DepartmentCodeName] NVARCHAR (125) NULL,
    [DepartmentHashKey]  NVARCHAR (200) NULL,
    [Dimension Code]     NVARCHAR (20)  NOT NULL,
    [ADF_BatchId_Insert] BIGINT         CONSTRAINT [DF_dim_Department_InsertBacthId] DEFAULT ((0)) NOT NULL,
    [ADF_BatchId_Update] BIGINT         CONSTRAINT [DF_dim_Department_UpdateBacthId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_dim_Department] PRIMARY KEY CLUSTERED ([DepartmentKey] ASC) WITH (DATA_COMPRESSION = ROW),
    CONSTRAINT [UQ_dim_Department] UNIQUE NONCLUSTERED ([CompanyID] ASC, [Dimension Code] ASC, [DepartmentCode] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

