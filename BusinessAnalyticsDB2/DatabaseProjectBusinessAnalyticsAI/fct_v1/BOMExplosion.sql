CREATE TABLE [fct_v1].[BOMExplosion] (
    [BOMExplosionKey] BIGINT IDENTITY (1, 1) NOT NULL,
    [CompanyKey] INT CONSTRAINT [DF_BOMExplosion_Company] DEFAULT ((-1)) NOT NULL,
    [TopItemKey] INT CONSTRAINT [DF_BOMExplosion_TopItem] DEFAULT ((-1)) NOT NULL,
    [ParentItemKey] INT CONSTRAINT [DF_BOMExplosion_ParentItem] DEFAULT ((-1)) NOT NULL,
    [ComponentItemKey] INT CONSTRAINT [DF_BOMExplosion_ComponentItem] DEFAULT ((-1)) NOT NULL,
    [TopBOMKey] INT CONSTRAINT [DF_BOMExplosion_TopBOM] DEFAULT ((-1)) NOT NULL,
    [LocationKey] INT NULL,
    [CompanyID] INT NOT NULL,
    [LocationCode] NVARCHAR (20) NULL,
    [TopItemNo] NVARCHAR (20) NOT NULL,
    [ParentItemNo] NVARCHAR (20) NULL,
    [ComponentNo] NVARCHAR (20) NULL,
    [TopBOMNo] NVARCHAR (20) NOT NULL,
    [ParentBOMNo] NVARCHAR (20) NULL,
    [SelectedVersionCode] NVARCHAR (20) NOT NULL,
    [Level] INT NOT NULL,
    [LineNo] INT NULL,
    [ComponentType] NVARCHAR (50) NULL,
    [ComponentTypeInt] INT NULL,
    [ComponentDescription] NVARCHAR (100) NULL,
    [ComponentVariantCode] NVARCHAR (10) NULL,
    [ComponentUOM] NVARCHAR (10) NULL,
    [Position] NVARCHAR (10) NULL,
    [RoutingLinkCode] NVARCHAR (20) NULL,
    [Path] NVARCHAR (4000) NOT NULL,
    [PathKey] CHAR (64) NOT NULL,
    [ParentPathKey] CHAR (64) NULL,
    [QuantityPerParent] DECIMAL (38, 20) NOT NULL,
    [ScrapPercent] DECIMAL (38, 20) NOT NULL,
    [QuantityPerTopItem] DECIMAL (38, 20) NOT NULL,
    [IsTopNode] BIT NOT NULL,
    [IsLeaf] BIT NOT NULL,
    [BOMStatus] NVARCHAR (50) NULL,
    [SystemModifiedAtMax] DATETIME2 (7) NULL,
    [ADF_BatchId_Insert] BIGINT CONSTRAINT [DF_BOMExplosion_InsertBatchId] DEFAULT ((0)) NOT NULL,
    [ADF_BatchId_Update] BIGINT CONSTRAINT [DF_BOMExplosion_UpdateBatchId] DEFAULT ((0)) NOT NULL,
    [ADF_PipelineTriggerTime] DATETIME CONSTRAINT [DF_BOMExplosion_PipelineTriggerTime] DEFAULT (GETDATE()) NOT NULL,
    CONSTRAINT [PK_BOMExplosion] PRIMARY KEY CLUSTERED ([BOMExplosionKey] ASC)
);


GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_BOMExplosion_TopItem_Path]
    ON [fct_v1].[BOMExplosion]([CompanyID] ASC, [TopItemNo] ASC, [PathKey] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_BOMExplosion_TopItem]
    ON [fct_v1].[BOMExplosion]([TopItemKey] ASC, [Level] ASC)
    INCLUDE([ComponentItemKey], [ComponentNo], [QuantityPerTopItem], [IsLeaf], [PathKey]);


GO

CREATE NONCLUSTERED INDEX [IX_BOMExplosion_ComponentItem]
    ON [fct_v1].[BOMExplosion]([ComponentItemKey] ASC, [CompanyID] ASC)
    INCLUDE([TopItemKey], [TopItemNo], [Level], [QuantityPerTopItem], [IsLeaf]);


GO

CREATE NONCLUSTERED INDEX [IX_BOMExplosion_TopBOM]
    ON [fct_v1].[BOMExplosion]([CompanyID] ASC, [TopBOMNo] ASC, [SelectedVersionCode] ASC)
    INCLUDE([TopItemNo], [Level], [ComponentNo], [QuantityPerTopItem], [PathKey]);


GO
