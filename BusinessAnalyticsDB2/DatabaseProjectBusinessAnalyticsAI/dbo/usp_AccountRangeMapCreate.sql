CREATE PROCEDURE [dbo].[usp_AccountRangeMapCreate]
AS
BEGIN
    /*
    Description: Expand AccountRangeRules into AccountRangeMap (Bridge Table)

        Version History:
        ----------------
        - v2.1 (Current): Added logic to handle 'Sum ReportName' filtering using [Calc2].
        - v2.0: Optimized and structured code for clarity and performance.
        - v1.x: Initial implementation with Basic Sum, Running Sums, Custom Rollups, and Range Sums.

    History:     
        2020-05-09 Bob, Created
        2024-12-23 JH, Converted to Scanpan Datawarehouse
        2025-01-16 JH, Tilføjet tæller for Range + udvidet forklarende tekster
        2025-01-31 JH, Tilføjet Sum ReportName, summer alle SUM fra et givet Report navn.
        2025-03-19 JH, Rettet RunningSum til kun at inkludere elementer fra samme Report
    */

    SET NOCOUNT ON;

    /*
        1) Clear existing data from ReportAccountMap
        - Ensures a fresh dataset before inserting new mappings.
        - TRUNCATE is faster than DELETE and resets identity values.
    */
    TRUNCATE TABLE [etl].[ReportAccountMap];

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
        3) Basic Sum Mappings:
        - Fetches accounts from DIM.GLAccount based on ReportAccountRules.
        - Matches Statement where Operator = 'Sum'.
    */
    INSERT INTO [etl].[ReportAccountMap] ([ReportNo], [Report], [AccountKey], [CompanyID], [Function])
    SELECT 
        r.[ReportNo], 
        r.[Report], 
        a.[GLAccountKey] AS [AccountKey],
        a.[CompanyID],
        'Sum' as [Function]
    FROM [DIM].[GLAccount] AS a
    INNER JOIN [etl].[ReportAccountRules] AS arr 
        ON a.[AccountNo] BETWEEN arr.[FromAccountNo] AND arr.[ToAccountNo]
        AND a.[CompanyID] = arr.[CompanyID]
    INNER JOIN [etl].[Statement] AS r 
        ON r.[ReportNo] = arr.[ReportNo]
    WHERE r.[Operator] = 'Sum';

    SET @BasicSumMappingsCount = @@ROWCOUNT;

    /*
        4) Running Sums:
        - Uses data already inserted in ReportAccountMap.
        - Accumulates data across multiple report lines where Operator = 'Running Sum'.
    */
    INSERT INTO [etl].[ReportAccountMap] ([ReportNo], [Report], [AccountKey], [CompanyID], [Function])
    SELECT 
        ar2.[ReportNo], 
        ar2.[Report], 
        m.[AccountKey],
        m.[CompanyID],
        'Running Sum' as [Function]
    FROM [etl].[ReportAccountMap] AS m
    INNER JOIN [etl].[Statement] AS ar 
        ON ar.[ReportNo] = m.[ReportNo]
        AND ar.[Report] = m.[Report]
    INNER JOIN [etl].[Statement] AS ar2 
        ON ar.[ReportNo] < ar2.[ReportNo]
        AND ar.[Report] = ar2.[Report]
    WHERE ar2.[Operator] = 'Running Sum';

    SET @RunningSumsCount = @@ROWCOUNT;

    /*
        5) Custom Rollups:
        - Looks at Calc1 in [ar].
        - If [ar2].Operator = 'Calc1' and [ar].Calc1 = 'Sum', we use mappings from [ar].
    */
    INSERT INTO [etl].[ReportAccountMap] ([ReportNo], [Report], [AccountKey], [CompanyID], [Function])
    SELECT 
        ar2.[ReportNo], 
        ar2.[Report], 
        m.[AccountKey],
        m.[CompanyID],
        'Sum Calc1' as [Function]
    FROM [etl].[ReportAccountMap] AS m
    INNER JOIN [etl].[Statement] AS ar 
        ON ar.[ReportNo] = m.[ReportNo]
    INNER JOIN [etl].[Statement] AS ar2 
        ON ar2.[ReportSection] = ar.[Calc1]
    WHERE ar2.[Operator] = 'Calc1'
      AND ar.[Calc1] = 'Sum';

    SET @CustomRollupsCount = @@ROWCOUNT;

    /*
        6) Range Sums:
        - Uses Operator='Range' in [f].
        - Interval [f].[Calc1]..[f].[Calc2] defines which [r2] lines with Operator='Sum' to include.
    */


    INSERT INTO [etl].[ReportAccountMap] ([ReportNo], [Report], [AccountKey], [CompanyID], [Function])
    SELECT 
        f.[ReportNo], 
        f.[Report],
        a.[GLAccountKey] AS [AccountKey],
        a.[CompanyID],
        'Range' as [Function]
    FROM [etl].[Statement] AS f
    JOIN [etl].[Statement] AS r2
        ON r2.[LineNo] BETWEEN f.[Calc1] AND f.[Calc2]
       AND r2.[Operator] = 'Sum'
    JOIN [etl].[ReportAccountRules] AS arr
        ON arr.[ReportNo] = r2.[ReportNo]
    JOIN [DIM].[GLAccount] AS a
        ON a.[AccountNo] BETWEEN arr.[FromAccountNo] AND arr.[ToAccountNo]
         AND a.[CompanyID] = arr.[CompanyID]
    WHERE f.[Operator] = 'Range';
    SET @RangeMappingsCount = @@ROWCOUNT;

    /*
        SELECT 
                f.[ReportNo]
                ,f.[Report]
                ,a.GLAccountKey
                ,CASE WHEN SumRpt.Report IS NULL THEN 'Range ' + f.Report ELSE 'Range ' + SumRpt.Report END AS [Function]

        FROM [etl].[Statement] AS f -- Original Statement ReportNo
            LEFT JOIN [etl].[Statement] AS Sumf -- Define Ranges 
                ON Sumf.[LineNo] BETWEEN f.Calc1 AND f.Calc2
            LEFT JOIN [etl].[Statement] AS SumRpt -- Define LinkeReport Ranges
                ON SumRpt.Report = Sumf.LinkReport
            LEFT JOIN [etl].ReportAccountRules arr -- Add AccountRule Lines
                ON (CASE WHEN SumRpt.ReportNo IS NULL THEN SumF.ReportNo ELSE SumRpt.ReportNo END) = arr.ReportNo    
            JOIN [DIM].[GLAccount] AS a  -- Add AccountNo Dim Key
                ON a.[AccountNo] BETWEEN arr.[FromAccountNo] AND arr.[ToAccountNo]  
        WHERE f.Operator = 'Range'
    */

    /*
        7) Sum Report Mappings:
        - New logic for Operator='Sum ReportName'.
        - Filters [Statement] using [Calc2] to match [Report].
    */
    INSERT INTO [etl].[ReportAccountMap] ([ReportNo], [Report], [AccountKey], [CompanyID], [Function])
    SELECT 
        f.[ReportNo]
        ,f.[Report]
        --,s.ReportNo
        --,arr.FromAccountNo
        --,arr.ToAccountNo
        --,a.AccountName
        ,a.GLAccountKey
        ,a.[CompanyID]
        --a.[GLAccountKey] AS [AccountKey]
        ,'Sum ReportName' as [Function]
    FROM [etl].[Statement] AS f  
    JOIN [etl].[Statement] AS s  
        ON s.[Report] = f.[LinkReport]  
       AND s.[Operator] = 'Sum'  
    JOIN [etl].ReportAccountRules arr 
        ON s.ReportNo = arr.ReportNo    
    JOIN [DIM].[GLAccount] AS a  
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

