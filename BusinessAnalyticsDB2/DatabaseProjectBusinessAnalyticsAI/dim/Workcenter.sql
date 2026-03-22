CREATE TABLE [dim].[Workcenter] (
    [WorkcenterKey]           INT            NOT NULL,
    [WorkcenterCompanyID]     INT            NOT NULL,
    [WorkcenterNumber]        NVARCHAR (20)  NOT NULL,
    [WorkcenterName]          NVARCHAR (50)  NOT NULL,
    [WorkcenterNumberName]    NVARCHAR (73)  NOT NULL,
    [WorkcenterGroup]         NVARCHAR (50)  NOT NULL,
    [WorkcenterDepartment]    NVARCHAR (50)  NOT NULL,
    [WorkcenterSubContractor] NVARCHAR (100) NOT NULL,
    [UnitOfMeasureCode]       NVARCHAR (10)  NOT NULL,
    [IsWorkcenterBlocked]     NVARCHAR (7)   NOT NULL,
    [WorkcenterLocation]      NVARCHAR (100) NOT NULL,
    [WorkcenterHashKey]       NVARCHAR (200) NULL,
    [ADF_BatchId_Insert]      BIGINT         CONSTRAINT [DF_dim_Workcenter_InsertBacthId] DEFAULT ((0)) NOT NULL,
    [ADF_BatchId_Update]      BIGINT         CONSTRAINT [DF_dim_Workcenter_UpdateBacthId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_dim_Workcenter] PRIMARY KEY CLUSTERED ([WorkcenterKey] ASC) WITH (DATA_COMPRESSION = ROW),
    CONSTRAINT [UQ_dim_Workcenter] UNIQUE NONCLUSTERED ([WorkcenterCompanyID] ASC, [WorkcenterNumber] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

