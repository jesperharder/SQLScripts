
CREATE VIEW [etl].[PriceList_DEVELOPING_VERSION]
AS 

-- PriceList from Business Central
-- Version 1 14.5.2024 JH
-- Version 2 6.6.2024 JH
-- Version 3 28.6.2024 JH
-- Version 4 ½.7.1014 JH PriceListCode
SELECT
    PL.CompanyID AS [CompanyID],
    PL.[Price List Code] AS [PriceListCode],  
    D.ItemKey AS [ItemKey], -- Adding a column from the joined table for demonstration
    PL.[Source Type] AS [SourceType],
    ST.SourceTypeDescription AS [SourceTypeDescription],
    PL.[Source No_] AS [SourceNo],
    PL.[Asset Type] AS [AssetType],
    AT.AssetTypeDescription AS [AssetTypeDescription],
    PL.[Asset No_] AS [AssetNo],
    PL.[Currency Code] AS [CurrencyCode],
    PL.[Starting Date] AS [StartingDate],
    NULLIF(PL.[Ending Date], '1753-01-01 00:00:00.000') as [EndingDate],
    CASE WHEN PL.[Ending Date] = '1753-01-01 00:00:00.000' THEN 1 ELSE -1 END AS [PriceIsOpenEndDate],
    PL.[Minimum Quantity] AS [MinimumQuantity],
    PL.[Unit of Measure Code] AS [UnitOfMeasureCode],
    PL.[Amount Type] AS [AmountType],
    AMT.AmountTypeDescription AS [AmountTypeDescription],
    PL.[Unit Price] AS [UnitPrice],
    PL.[Cost Factor] AS [CostFactor],
    PL.[Unit Cost] AS [UnitCost],
    PL.[Line Discount _] AS [LineDiscount],
    PL.[Allow Line Disc_] AS [AllowLineDisc],
    PL.[Allow Invoice Disc_] AS [AllowInvoiceDisc],
    PL.[Price Includes VAT] AS [PriceIncludesVAT],
    PL.[VAT Bus_ Posting Gr_ (Price)] AS [VATBusPostingGroupPrice],
    PL.[VAT Prod_ Posting Group] AS [VATProdPostingGroup],
    PL.[Line Amount] AS [LineAmount],
    PL.[Price Type] AS [PriceType],
    PT.PriceTypeDescription AS [PriceTypeDescription],
    PL.[Description] AS [Description],
    PL.[Status] AS [Status],
    STS.StatusDescription AS [StatusDescription],
    PL.[Direct Unit Cost] AS [DirectUnitCost],
    PL.[Source Group] AS [SourceGroup],
    SG.SourceGroupDescription AS [SourceGroupDescription]
FROM
    stg_bc.PricelistLine PL
    LEFT JOIN (
        SELECT 
            0 AS SourceTypeNo, 'Price Source - All' AS SourceTypeDescription
        UNION ALL SELECT 
            10 AS SourceTypeNo, 'Price Source - All Customers' AS SourceTypeDescription
        UNION ALL SELECT 
            11 AS SourceTypeNo, 'Price Source - Customer' AS SourceTypeDescription
        UNION ALL SELECT 
            12 AS SourceTypeNo, 'Price Source - Cust. Price Gr.' AS SourceTypeDescription
        UNION ALL SELECT 
            13 AS SourceTypeNo, 'Price Source - Cust. Disc. Gr.' AS SourceTypeDescription
        UNION ALL SELECT 
            20 AS SourceTypeNo, 'Price Source - All Vendors' AS SourceTypeDescription
        UNION ALL SELECT 
            21 AS SourceTypeNo, 'Price Source - Vendor' AS SourceTypeDescription
        UNION ALL SELECT 
            30 AS SourceTypeNo, 'Price Source - All Jobs' AS SourceTypeDescription
        UNION ALL SELECT 
            31 AS SourceTypeNo, 'Price Source - Job' AS SourceTypeDescription
        UNION ALL SELECT 
            32 AS SourceTypeNo, 'Price Source - Job Task' AS SourceTypeDescription
        UNION ALL SELECT 
            50 AS SourceTypeNo, 'Price Source - Campaign' AS SourceTypeDescription
        UNION ALL SELECT 
            51 AS SourceTypeNo, 'Price Source - Contact' AS SourceTypeDescription
    ) AS ST ON PL.[Source Type] = ST.SourceTypeNo
    LEFT JOIN (
        SELECT 
            0 AS AssetTypeNo, 'Price Asset - All' AS AssetTypeDescription
        UNION ALL SELECT 
            10 AS AssetTypeNo, 'Price Asset - Item' AS AssetTypeDescription
        UNION ALL SELECT 
            20 AS AssetTypeNo, 'Price Asset - Item Disc. Group' AS AssetTypeDescription
        UNION ALL SELECT 
            30 AS AssetTypeNo, 'Price Asset - Resource' AS AssetTypeDescription
        UNION ALL SELECT 
            40 AS AssetTypeNo, 'Price Asset - Resource Group' AS AssetTypeDescription
        UNION ALL SELECT 
            50 AS AssetTypeNo, 'Price Asset - Service Cost' AS AssetTypeDescription
        UNION ALL SELECT 
            60 AS AssetTypeNo, 'Price Asset - G/L Account' AS AssetTypeDescription
    ) AS AT ON PL.[Asset Type] = AT.AssetTypeNo
    LEFT JOIN (
        SELECT 
            0 AS AmountTypeNo, 'Price & Discount' AS AmountTypeDescription
        UNION ALL SELECT 
            17 AS AmountTypeNo, 'Price' AS AmountTypeDescription
        UNION ALL SELECT 
            19 AS AmountTypeNo, 'Obsolete' AS AmountTypeDescription -- Note: 'Cost' is handled as 'Obsolete'
        UNION ALL SELECT 
            20 AS AmountTypeNo, 'Discount' AS AmountTypeDescription
    ) AS AMT ON PL.[Amount Type] = AMT.AmountTypeNo
    LEFT JOIN (
        SELECT 
            0 AS PriceTypeNo, 'Any' AS PriceTypeDescription
        UNION ALL SELECT 
            1 AS PriceTypeNo, 'Sale' AS PriceTypeDescription
        UNION ALL SELECT 
            2 AS PriceTypeNo, 'Purchase' AS PriceTypeDescription
    ) AS PT ON PL.[Price Type] = PT.PriceTypeNo
    LEFT JOIN (
        SELECT 
            0 AS StatusNo, 'Draft' AS StatusDescription
        UNION ALL SELECT 
            1 AS StatusNo, 'Active' AS StatusDescription
        UNION ALL SELECT 
            2 AS StatusNo, 'Inactive' AS StatusDescription
    ) AS STS ON PL.[Status] = STS.StatusNo
    LEFT JOIN (
        SELECT 
            0 AS SourceGroupNo, '(All)' AS SourceGroupDescription
        UNION ALL SELECT 
            11 AS SourceGroupNo, 'Customer' AS SourceGroupDescription
        UNION ALL SELECT 
            21 AS SourceGroupNo, 'Vendor' AS SourceGroupDescription
        UNION ALL SELECT 
            31 AS SourceGroupNo, 'Job' AS SourceGroupDescription
    ) AS SG ON PL.[Source Group] = SG.SourceGroupNo
    LEFT JOIN [dim].[Item] D ON PL.[Asset No_] = D.ItemNo AND PL.CompanyID = D.ItemCompanyID AND PL.[Asset Type] = 10;

GO

