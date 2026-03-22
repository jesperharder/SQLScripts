CREATE view [dbo].[DimKaede] as
SELECT       [CompanyID], [Dimension Code], Code AS ChainDim, Name AS Chain_Description, Code + '-' + Name AS [Chain Description]
FROM            stg_navdb.DimensionValue
WHERE        ([Dimension Code] = N'KAEDE')

GO

