CREATE VIEW [etl].[DimTeamSource]
AS
	SELECT [ts].[Team Code] AS [TeamCode]
		  ,[sp].[Name] AS [TeamName]
		  ,[ts].[Salesperson Code] AS [TeamPersonCode]
		  ,[spp].[Name] AS [TeamPersonName]
		  ,[ts].[CompanyID] AS [TeamCompanyID]
	FROM [stg_bc].[TeamSalesperson] AS [ts]
	LEFT JOIN [stg_bc].[SalespersonPurchaser] AS [sp]
	ON  [sp].[CompanyID] = [ts].[CompanyID]
	AND [sp].[Code] = [ts].[Team Code]
	LEFT JOIN [stg_bc].[SalespersonPurchaser] AS [spp]
	ON  [spp].[CompanyID] = [ts].[CompanyID]
	AND [spp].[Code] = [ts].[Salesperson Code]
	UNION
	SELECT [ts].[Team Code] AS [TeamCode]
		  ,[sp].[Name] AS [TeamName]
		  ,[ts].[Salesperson Code] AS [TeamPersonCode]
		  ,[spp].[Name] AS [TeamPersonName]
		  ,[ts].[CompanyID] AS [TeamCompanyID]
	FROM [stg_navdb].[TeamSalesperson] AS [ts]
	LEFT JOIN [stg_navdb].[SalespersonPurchaser] AS [sp]
	ON  [sp].[CompanyID] = [ts].[CompanyID]
	AND [sp].[Code] = [ts].[Team Code]
	LEFT JOIN [stg_navdb].[SalespersonPurchaser] AS [spp]
	ON  [spp].[CompanyID] = [ts].[CompanyID]
	AND [spp].[Code] = [ts].[Salesperson Code]
	WHERE NOT EXISTS
	(
		SELECT 1
		FROM [stg_bc].[TeamSalesperson] AS [ts_bc]
		WHERE TRIM([ts].[Salesperson Code]) = TRIM([ts_bc].[Salesperson Code])
		AND   TRIM([ts].[Team Code]) = TRIM([ts_bc].[Team Code])
		AND   [ts].[CompanyID] = [ts_bc].[CompanyID]
	)
	UNION
	SELECT N'' AS [TeamCode]
		  ,N'' AS [TeamName]
		  ,[sp].[Code] AS [TeamPersonCode]
		  ,[sp].[Name] AS [TeamPersonName]
		  ,[sp].[CompanyID] AS [TeamCompanyID]
	FROM [stg_bc].[SalespersonPurchaser] AS [sp]
	WHERE NOT EXISTS
	(
		SELECT 1
		FROM [stg_bc].[TeamSalesperson] AS [ts_bc]
		WHERE TRIM([sp].[Code]) = TRIM([ts_bc].[Salesperson Code])
		AND   [sp].[CompanyID] = [ts_bc].[CompanyID]
	)
	AND   NOT EXISTS
	(
		SELECT 1
		FROM [stg_navdb].[TeamSalesperson] AS [ts_bc]
		WHERE TRIM([sp].[Code]) = TRIM([ts_bc].[Salesperson Code])
		AND   [sp].[CompanyID] = [ts_bc].[CompanyID]
	)
	UNION
	SELECT N'' AS [TeamCode]
		  ,N'' AS [TeamName]
		  ,[sp].[Code] AS [TeamPersonCode]
		  ,[sp].[Name] AS [TeamPersonName]
		  ,[sp].[CompanyID] AS [TeamCompanyID]
	FROM [stg_navdb].[SalespersonPurchaser] AS [sp]
	WHERE NOT EXISTS
	(
		SELECT 1
		FROM [stg_bc].[TeamSalesperson] AS [ts_bc]
		WHERE TRIM([sp].[Code]) = TRIM([ts_bc].[Salesperson Code])
		AND   [sp].[CompanyID] = [ts_bc].[CompanyID]
	)
	AND   NOT EXISTS
	(
		SELECT 1
		FROM [stg_navdb].[TeamSalesperson] AS [ts_bc]
		WHERE TRIM([sp].[Code]) = TRIM([ts_bc].[Salesperson Code])
		AND   [sp].[CompanyID] = [ts_bc].[CompanyID]
	)
	AND   NOT EXISTS
	(
		SELECT 1
		FROM [stg_bc].[SalespersonPurchaser] AS [sp2]
		WHERE [sp2].[CompanyID] = [sp].[CompanyID]
		AND   [sp2].[Code] = [sp].[Code]
	)

GO

