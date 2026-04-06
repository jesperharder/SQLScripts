CREATE PROCEDURE [etl_v1].[LoadFactBOMExplosion]
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE [fct_v1].[BOMExplosion];

    INSERT INTO [fct_v1].[BOMExplosion]
    (
        [CompanyKey],
        [TopItemKey],
        [ParentItemKey],
        [ComponentItemKey],
        [TopBOMKey],
        [LocationKey],
        [CompanyID],
        [LocationCode],
        [TopItemNo],
        [ParentItemNo],
        [ComponentNo],
        [TopBOMNo],
        [ParentBOMNo],
        [SelectedVersionCode],
        [Level],
        [LineNo],
        [ComponentType],
        [ComponentTypeInt],
        [ComponentDescription],
        [ComponentVariantCode],
        [ComponentUOM],
        [Position],
        [RoutingLinkCode],
        [Path],
        [PathKey],
        [ParentPathKey],
        [QuantityPerParent],
        [ScrapPercent],
        [QuantityPerTopItem],
        [IsTopNode],
        [IsLeaf],
        [BOMStatus],
        [SystemModifiedAtMax]
    )
    EXEC [etl_v1].[GetRowsFactBOMExplosion];
END;


GO
