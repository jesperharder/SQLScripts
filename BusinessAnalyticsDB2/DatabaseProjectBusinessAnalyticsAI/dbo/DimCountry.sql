CREATE view [dbo].[DimCountry] as
SELECT       [CompanyID], [Dimension Code], Code AS CountryDim, Name AS Country_Description, Code + '-' + Name AS [Country Description]
FROM            stg_navdb.DimensionValue
WHERE        ([Dimension Code] = N'LAND')

GO

