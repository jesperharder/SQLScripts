CREATE PROCEDURE [dbo].[usp_AccountRangeMapCreate_v1]
AS
BEGIN
    /*
    Description: Expand AccountRangeRules into ReportAccountMap for V1 GLAccount keys

        Version History:
        ----------------
        - v1.0 (Current): V1 version of classic report account map rebuild.

    History:
        2026-04-08 Codex, Created V1 version using [dim_v1].[GLAccount] and [etl_v1].[ReportAccountMap]
    */

    SET NOCOUNT ON;

    /*
        1) Clear existing data from ReportAccountMap.
    */
    TRUNCATE TABLE [etl_v1].[ReportAccountMap];

    /*
        2) Declare counters for different mapping strategies.
    */
    DECLARE @BasicSumMappingsCount   INT;
    DECLARE @RunningSumsCount        INT;
    DECLARE @CustomRollupsCount      INT;
    DECLARE @RangeMappingsCount      INT;
    DECLARE @SumReportMappingsCount  INT;
    DECLARE @TotalCount              INT;

    /*
        3) Basic Sum mappings.
    */
    INSERT INTO [etl_v1].[ReportAccountMap] ([ReportNo], [Report], [AccountKey], [CompanyID], [Function])
    SELECT
        r.[ReportNo],
        r.[Report],
        a.[GLAccountKey] AS [AccountKey],
        a.[CompanyID],
        'Sum' AS [Function]
    FROM [dim_v1].[GLAccount] AS a
    INNER JOIN [etl].[ReportAccountRules] AS arr
        ON a.[AccountNo] BETWEEN arr.[FromAccountNo] AND arr.[ToAccountNo]
       AND a.[CompanyID] = arr.[CompanyID]
    INNER JOIN [etl].[Statement] AS r
        ON r.[ReportNo] = arr.[ReportNo]
    WHERE r.[Operator] = 'Sum';

    SET @BasicSumMappingsCount = @@ROWCOUNT;

    /*
        4) Running sums.
    */
    INSERT INTO [etl_v1].[ReportAccountMap] ([ReportNo], [Report], [AccountKey], [CompanyID], [Function])
    SELECT
        ar2.[ReportNo],
        ar2.[Report],
        m.[AccountKey],
        m.[CompanyID],
        'Running Sum' AS [Function]
    FROM [etl_v1].[ReportAccountMap] AS m
    INNER JOIN [etl].[Statement] AS ar
        ON ar.[ReportNo] = m.[ReportNo]
       AND ar.[Report] = m.[Report]
    INNER JOIN [etl].[Statement] AS ar2
        ON ar.[ReportNo] < ar2.[ReportNo]
       AND ar.[Report] = ar2.[Report]
    WHERE ar2.[Operator] = 'Running Sum';

    SET @RunningSumsCount = @@ROWCOUNT;

    /*
        5) Custom rollups.
    */
    INSERT INTO [etl_v1].[ReportAccountMap] ([ReportNo], [Report], [AccountKey], [CompanyID], [Function])
    SELECT
        ar2.[ReportNo],
        ar2.[Report],
        m.[AccountKey],
        m.[CompanyID],
        'Sum Calc1' AS [Function]
    FROM [etl_v1].[ReportAccountMap] AS m
    INNER JOIN [etl].[Statement] AS ar
        ON ar.[ReportNo] = m.[ReportNo]
    INNER JOIN [etl].[Statement] AS ar2
        ON ar2.[ReportSection] = ar.[Calc1]
    WHERE ar2.[Operator] = 'Calc1'
      AND ar.[Calc1] = 'Sum';

    SET @CustomRollupsCount = @@ROWCOUNT;

    /*
        6) Range sums.
    */
    INSERT INTO [etl_v1].[ReportAccountMap] ([ReportNo], [Report], [AccountKey], [CompanyID], [Function])
    SELECT
        f.[ReportNo],
        f.[Report],
        a.[GLAccountKey] AS [AccountKey],
        a.[CompanyID],
        'Range' AS [Function]
    FROM [etl].[Statement] AS f
    INNER JOIN [etl].[Statement] AS r2
        ON r2.[LineNo] BETWEEN f.[Calc1] AND f.[Calc2]
       AND r2.[Operator] = 'Sum'
    INNER JOIN [etl].[ReportAccountRules] AS arr
        ON arr.[ReportNo] = r2.[ReportNo]
    INNER JOIN [dim_v1].[GLAccount] AS a
        ON a.[AccountNo] BETWEEN arr.[FromAccountNo] AND arr.[ToAccountNo]
       AND a.[CompanyID] = arr.[CompanyID]
    WHERE f.[Operator] = 'Range';

    SET @RangeMappingsCount = @@ROWCOUNT;

    /*
        7) Sum ReportName mappings.
    */
    INSERT INTO [etl_v1].[ReportAccountMap] ([ReportNo], [Report], [AccountKey], [CompanyID], [Function])
    SELECT
        f.[ReportNo],
        f.[Report],
        a.[GLAccountKey] AS [AccountKey],
        a.[CompanyID],
        'Sum ReportName' AS [Function]
    FROM [etl].[Statement] AS f
    INNER JOIN [etl].[Statement] AS s
        ON s.[Report] = f.[LinkReport]
       AND s.[Operator] = 'Sum'
    INNER JOIN [etl].[ReportAccountRules] AS arr
        ON s.[ReportNo] = arr.[ReportNo]
    INNER JOIN [dim_v1].[GLAccount] AS a
        ON a.[AccountNo] BETWEEN arr.[FromAccountNo] AND arr.[ToAccountNo]
       AND a.[CompanyID] = arr.[CompanyID]
    WHERE f.[Operator] = 'Sum ReportName'
      AND f.[LinkReport] = s.[Report];

    SET @SumReportMappingsCount = @@ROWCOUNT;

    /*
        8) Calculate total inserted count.
    */
    SET @TotalCount =
          @BasicSumMappingsCount
        + @RunningSumsCount
        + @CustomRollupsCount
        + @RangeMappingsCount
        + @SumReportMappingsCount;

    /*
        9) Return summary of inserted row counts.
    */
    SELECT
        @BasicSumMappingsCount   AS [BasicSumMappingsCount],
        @RunningSumsCount        AS [RunningSumsCount],
        @CustomRollupsCount      AS [CustomRollupsCount],
        @RangeMappingsCount      AS [RangeMappingsCount],
        @SumReportMappingsCount  AS [SumReportMappingsCount],
        @TotalCount              AS [TotalInsertedCount];
END

GO
