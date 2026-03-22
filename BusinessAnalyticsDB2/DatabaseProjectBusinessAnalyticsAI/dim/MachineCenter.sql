CREATE TABLE [dim].[MachineCenter] (
    [MachineCenterKey]        INT            NOT NULL,
    [MachineCenterCompanyID]  INT            NOT NULL,
    [MachineCenterNumber]     NVARCHAR (20)  NOT NULL,
    [MachineCenterName]       NVARCHAR (50)  NOT NULL,
    [MachineCenterNumberName] NVARCHAR (73)  NOT NULL,
    [MachineCenterHashKey]    NVARCHAR (200) NULL,
    [ADF_BatchId_Insert]      BIGINT         CONSTRAINT [DF_dim_MachineCenter_InsertBacthId] DEFAULT ((0)) NOT NULL,
    [ADF_BatchId_Update]      BIGINT         CONSTRAINT [DF_dim_MachineCenter_UpdateBacthId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_dim_MachineCenter] PRIMARY KEY CLUSTERED ([MachineCenterKey] ASC) WITH (DATA_COMPRESSION = ROW),
    CONSTRAINT [UQ_dim_MachineCenter] UNIQUE NONCLUSTERED ([MachineCenterCompanyID] ASC, [MachineCenterNumber] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

