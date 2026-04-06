CREATE PROCEDURE [etl_v1].[LoadFactBOMExplosion]
    @CompanyID INT,
    @TopItemNo NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    IF @CompanyID IS NULL AND @TopItemNo IS NULL
    BEGIN
        TRUNCATE TABLE [fct_v1].[BOMExplosion];
    END
    ELSE
    BEGIN
        DELETE FROM [fct_v1].[BOMExplosion]
        WHERE (@CompanyID IS NULL OR [CompanyID] = @CompanyID)
          AND (@TopItemNo IS NULL OR [TopItemNo] = @TopItemNo);
    END

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
    EXEC [etl_v1].[GetRowsFactBOMExplosion]
        @CompanyID = @CompanyID,
        @TopItemNo = @TopItemNo;
END;


GO
