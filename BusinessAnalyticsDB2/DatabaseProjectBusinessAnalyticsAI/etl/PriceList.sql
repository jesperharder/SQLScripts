CREATE VIEW [etl].[PriceList]
as 
SELECT
         PL.CompanyID as [CompanyID]
         ,PL.[Source Type] as [SourceType]
         ,ST.SourceTypeDescription as [SourceTypeDescription]
         ,PL.[Price List Code] as [PriceListCode]
         ,PL.[Currency Code] as [CurrencyCode]
         ,PL.[Starting Date] as [StartingDate]
         ,NULLIF(PL.[Ending Date], '1753-01-01 00:00:00.000') as [EndingDate]
         ,CASE WHEN PL.[Ending Date] = '1753-01-01 00:00:00.000' THEN 1 ELSE -1 END AS [PriceIsOpenEndDate]
         ,PL.[Line No_] as [PriceListLineNo]
         ,PL.[Source No_] as [SourceNo]
         ,PL.[Asset Type] as [AssetType9]
         ,AT.AssetTypeDescription as [AssetTypeDescription]
         ,PL.[Asset No_] as [AssetNo]
         ,PL.[Unit of Measure Code] as [UnitOfMeasureCode]
         ,PL.[Amount Type] as [AmountType]
         ,AMT.AmountTypeDescription as [AmountTypeDescription]
         ,PL.[Minimum Quantity] as [MinumumQuantity]
         ,PL.[Unit Price] as [UnitPrice]
from 
        stg_bc.PricelistLine PL            
        left join (SELECT SourceTypeNo, SourceTypeDescription FROM 
            (
            SELECT 0 AS SourceTypeNo, 'All' as SourceTypeDescription
            UNION ALL SELECT 10 AS SourceTypeNo, 'All Customers' as SourceTypeDescription
            UNION ALL SELECT 11 AS SourceTypeNo, 'Customer' as SourceTypeDescription
            UNION ALL SELECT 12 AS SourceTypeNo, 'Customer Price Group' as SourceTypeDescription
            UNION ALL SELECT 13 AS SourceTypeNo, 'Customer Disc. Group' as SourceTypeDescription
            UNION ALL SELECT 20 AS SourceTypeNo, 'All Vendors' as SourceTypeDescription
            UNION ALL SELECT 21 AS SourceTypeNo, 'Vendor' as SourceTypeDescription
            UNION ALL SELECT 30 AS SourceTypeNo, 'All Jobs' as SourceTypeDescription
            UNION ALL SELECT 31 AS SourceTypeNo, 'Job' as SourceTypeDescription
            UNION ALL SELECT 32 AS SourceTypeNo, 'Job Task' as SourceTypeDescription
            UNION ALL SELECT 50 AS SourceTypeNo, 'Campaign' as SourceTypeDescription
            UNION ALL SELECT 51 AS SourceTypeNo, 'Contact' as SourceTypeDescription
            ) as S) 
        as ST ON PL.[Source Type] = ST.SourceTypeNo
        left join (SELECT AssetTypeNo, AssetTypeDescription FROM
            (
            SELECT 0 as AssetTypeNo, 'All' as AssetTypeDescription
            UNION ALL SELECT 10 as AssetTypeNo, 'Item' as AssetTypeDescription
            UNION ALL SELECT 20 as AssetTypeNo, 'Item Discount Group' as AssetTypeDescription
            UNION ALL SELECT 30 as AssetTypeNo, 'Ressource' as AssetTypeDescription
            UNION ALL SELECT 40 as AssetTypeNo, 'Ressource Group' as AssetTypeDescription
            UNION ALL SELECT 50 as AssetTypeNo, 'Service Cost' as AssetTypeDescription
            UNION ALL SELECT 60 as AssetTypeNo, 'G/L Account' as AssetTypeDescription
            ) as AssetType) as AT ON PL.[Asset Type] = AT.AssetTypeNo
        left join (SELECT AmountTypeNo, AmountTypeDescription FROM
            (
            SELECT 0 as AmountTypeNo, 'Price & Discount' as AmountTypeDescription
            UNION ALL SELECT 17 as AmountTypeNo, 'Price' as AmountTypeDescription
            UNION ALL SELECT 19 as AmountTypeNo, 'Cost' as AmountTypeDescription
            UNION ALL SELECT 20 as AmountTypeNo, 'Discount' as AmountTypeDescription
            ) as AmountType) as AMT ON PL.[Amount Type] = AMT.AmountTypeNo

--WHERE ST.SourceTypeNo = 12

GO

