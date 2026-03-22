CREATE TABLE [dim].[Vendor] (
    [VendorKey]                    INT            NOT NULL,
    [CompanyID]                    INT            NOT NULL,
    [VendorNumber]                 NVARCHAR (20)  NOT NULL,
    [VendorName]                   NVARCHAR (100) NULL,
    [VendorCountry]                NVARCHAR (10)  NOT NULL,
    [VendorNumberName]             NVARCHAR (125) NULL,
    [VendorCompanyPublicRegNumber] NVARCHAR (20)  NULL,
    [VendorHashKey]                NVARCHAR (200) NULL,
    [ADF_BatchId_Insert]           BIGINT         CONSTRAINT [DF_dim_Vendor_InsertBacthId] DEFAULT ((0)) NOT NULL,
    [ADF_BatchId_Update]           BIGINT         CONSTRAINT [DF_dim_Vendor_UpdateBacthId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_dim_Vendor] PRIMARY KEY CLUSTERED ([VendorKey] ASC) WITH (DATA_COMPRESSION = ROW),
    CONSTRAINT [UQ_dim_Vendor] UNIQUE NONCLUSTERED ([CompanyID] ASC, [VendorNumber] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

