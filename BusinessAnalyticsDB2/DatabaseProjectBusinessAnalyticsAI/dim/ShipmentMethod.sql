CREATE TABLE [dim].[ShipmentMethod] (
    [ShipmentMethodKey]       INT            NOT NULL,
    [ShipmentMethodCompanyID] INT            NOT NULL,
    [ShipmentMethodCode]      NVARCHAR (20)  NOT NULL,
    [ShipmentMethodName]      NVARCHAR (100) NULL,
    [ShipmentMethodCodeName]  NVARCHAR (125) NULL,
    [ShipmentMethodHashKey]   NVARCHAR (200) NULL,
    [ADF_BatchId_Insert]      BIGINT         CONSTRAINT [DF_dim_ShipmentMethod_InsertBacthId] DEFAULT ((0)) NOT NULL,
    [ADF_BatchId_Update]      BIGINT         CONSTRAINT [DF_dim_ShipmentMethod_UpdateBacthId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_dim_ShipmentMethod] PRIMARY KEY CLUSTERED ([ShipmentMethodKey] ASC) WITH (DATA_COMPRESSION = ROW),
    CONSTRAINT [UQ_dim_ShipmentMethod] UNIQUE NONCLUSTERED ([ShipmentMethodCompanyID] ASC, [ShipmentMethodCode] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

