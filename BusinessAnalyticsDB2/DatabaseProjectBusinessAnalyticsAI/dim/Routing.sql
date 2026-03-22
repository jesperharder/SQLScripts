CREATE TABLE [dim].[Routing] (
    [RoutingKey]         INT            NOT NULL,
    [RoutingCompanyID]   INT            NOT NULL,
    [RoutingNumber]      NVARCHAR (20)  NOT NULL,
    [RoutingName]        NVARCHAR (50)  NOT NULL,
    [RoutingNumberName]  NVARCHAR (73)  NOT NULL,
    [RoutingStatus]      NVARCHAR (22)  NOT NULL,
    [RoutingType]        NVARCHAR (20)  NOT NULL,
    [RoutingHashKey]     NVARCHAR (200) NULL,
    [ADF_BatchId_Insert] BIGINT         CONSTRAINT [DF_dim_Routing_InsertBacthId] DEFAULT ((0)) NOT NULL,
    [ADF_BatchId_Update] BIGINT         CONSTRAINT [DF_dim_Routing_UpdateBacthId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_dim_Routing] PRIMARY KEY CLUSTERED ([RoutingKey] ASC) WITH (DATA_COMPRESSION = ROW),
    CONSTRAINT [UQ_dim_Routing] UNIQUE NONCLUSTERED ([RoutingCompanyID] ASC, [RoutingNumber] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

