CREATE VIEW [etl_v1].[DimTeamSource]
AS
	SELECT [ts].[teamCode] AS [TeamCode]
		  ,[sp].[Name] AS [TeamName]
		  ,[ts].[salespersonCode] AS [TeamPersonCode]
		  ,[spp].[Name] AS [TeamPersonName]
		  ,[ts].[CompanyID] AS [TeamCompanyID]
	FROM [stg_bc_api].[TeamSalesperson] AS [ts]
	LEFT JOIN [stg_bc_api].[SalespersonPurchaser] AS [sp]
	ON  [sp].[CompanyID] = [ts].[CompanyID]
	AND [sp].[Code] = [ts].[teamCode]
	LEFT JOIN [stg_bc_api].[SalespersonPurchaser] AS [spp]
	ON  [spp].[CompanyID] = [ts].[CompanyID]
	AND [spp].[Code] = [ts].[salespersonCode]
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
		FROM [stg_bc_api].[TeamSalesperson] AS [ts_bc]
		WHERE TRIM([ts].[Salesperson Code]) = TRIM([ts_bc].[salespersonCode])
		AND   TRIM([ts].[Team Code]) = TRIM([ts_bc].[teamCode])
		AND   [ts].[CompanyID] = [ts_bc].[CompanyID]
	)
	UNION
	SELECT N'' AS [TeamCode]
		  ,N'' AS [TeamName]
		  ,[sp].[Code] AS [TeamPersonCode]
		  ,[sp].[Name] AS [TeamPersonName]
		  ,[sp].[CompanyID] AS [TeamCompanyID]
	FROM [stg_bc_api].[SalespersonPurchaser] AS [sp]
	WHERE NOT EXISTS
	(
		SELECT 1
		FROM [stg_bc_api].[TeamSalesperson] AS [ts_bc]
		WHERE TRIM([sp].[Code]) = TRIM([ts_bc].[salespersonCode])
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
		FROM [stg_bc_api].[TeamSalesperson] AS [ts_bc]
		WHERE TRIM([sp].[Code]) = TRIM([ts_bc].[salespersonCode])
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
		FROM [stg_bc_api].[SalespersonPurchaser] AS [sp2]
		WHERE [sp2].[CompanyID] = [sp].[CompanyID]
		AND   [sp2].[Code] = [sp].[Code]
	)

GO

