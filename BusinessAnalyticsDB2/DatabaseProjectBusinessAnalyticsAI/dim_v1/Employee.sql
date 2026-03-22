CREATE TABLE [dim_v1].[Employee] (
    [EmployeeKey]        INT            NOT NULL,
    [EmployeeCode]       NVARCHAR (20)  NOT NULL,
    [EmployeeName]       NVARCHAR (100) NULL,
    [EmployeeCodeName]   NVARCHAR (125) NULL,
    [EmployeeHashKey]    NVARCHAR (200) NULL,
    [Dimension Code]     NVARCHAR (20)  NOT NULL,
    [CompanyID]          INT            NOT NULL,
    [ADF_BatchId_Insert] BIGINT         CONSTRAINT [DF_dim_Employee_InsertBacthId] DEFAULT ((0)) NOT NULL,
    [ADF_BatchId_Update] BIGINT         CONSTRAINT [DF_dim_Employee_UpdateBacthId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_dim_Employee] PRIMARY KEY CLUSTERED ([EmployeeKey] ASC),
    CONSTRAINT [UQ_dim_Employee] UNIQUE NONCLUSTERED ([CompanyID] ASC, [Dimension Code] ASC, [EmployeeCode] ASC)
);


GO

