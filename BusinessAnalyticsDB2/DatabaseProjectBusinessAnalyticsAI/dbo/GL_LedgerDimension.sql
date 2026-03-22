CREATE VIEW GL_LedgerDimension as
SELECT DISTINCT 
                         TOP (100) PERCENT [CompanyID],  [Entry No_], CASE WHEN [Dimension Code] = 'AFDELING' THEN [Dimension Value Code] END AS DimAfdeling, CASE WHEN [Dimension Code] = 'KÆDE' THEN [Dimension Value Code] END AS DimKaede, 
                         CASE WHEN [Dimension Code] = 'LAND' THEN [Dimension Value Code] END AS DimLand, 1 AS antal
FROM            stg_navdb.LedgerEntryDimension
WHERE        ([Dimension Code] IN ('LAND', 'KÆDE', 'AFDELING')) AND ([Table ID] = 17) and [CompanyID]=1
ORDER BY [Entry No_]

GO

