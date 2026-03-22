CREATE   PROCEDURE [etl].[GetRowsFactCurrencyExhangeRate]
AS
BEGIN
--2024.05.16JH  Fixing crossover rates and introducing ComapnyID

      SET NOCOUNT ON;

    DECLARE @Number table
    (
        [Number] int NOT NULL PRIMARY KEY CLUSTERED
    );

    DECLARE @base table
    (
        [CompanyID] integer NOT NULL
        ,[FromCurrency] nvarchar(20) NOT NULL
       ,[ToCurrency] nvarchar(20) NOT NULL
       ,[StartDate] datetime NOT NULL
       ,[EndDate] datetime NOT NULL
       ,[ExchangeRate] decimal(18, 6) NOT NULL
       ,PRIMARY KEY CLUSTERED
        (
            [CompanyID] ASC
            ,[FromCurrency] ASC
            ,[ToCurrency] ASC
            ,[StartDate] ASC
            ,[EndDate] ASC
        )
    );

    DECLARE @ExcangeRatesDate table
    (   [CompanyID] integer NOT NULL
        ,[FromCurrency] nvarchar(20) NOT NULL
        ,[ToCurrency] nvarchar(20) NOT NULL
        ,[DateKey] int NOT NULL
        ,[ExchangeRate] decimal(18, 6) NOT NULL
        ,PRIMARY KEY CLUSTERED
            (   [CompanyID] ASC
                ,[FromCurrency] ASC
                ,[ToCurrency] ASC
                ,[DateKey] ASC
            )
        ,INDEX [ExchangeRateDate_FromCurrency_DateKey_WithIncluded] NONCLUSTERED([CompanyID] ASC, [FromCurrency] ASC, [DateKey] ASC)INCLUDE([ExchangeRate])
    );

    DECLARE @Triangulated table
    (   [CompanyID] int NOT NULL
        ,[DateKey] int NOT NULL
        ,[ToCurrency] nvarchar(20) NOT NULL
        ,[FromCurrency] nvarchar(20) NOT NULL
        ,[ExchangeRateTo] decimal(18, 6) NOT NULL
        ,[ExchangeRateFrom] decimal(18, 6) NOT NULL
    );

    INSERT INTO @base
    (   [CompanyID]
        ,[FromCurrency]
        ,[ToCurrency]
        ,[StartDate]
        ,[EndDate]
        ,[ExchangeRate]
    )
    SELECT 
        [src].[CompanyID]
        ,[src].[FromCurrency]
        ,[src].[ToCurrency]
        ,[src].[StartDate]
        ,ISNULL(DATEADD(DAY, -1, LEAD([src].[StartDate], 1) OVER (PARTITION BY [src].[CompanyID], [src].[FromCurrency], [src].[ToCurrency] ORDER BY [src].[CompanyID],[src].[StartDate])), CAST(CAST(EOMONTH(GETDATE()) AS date) AS datetime)) AS [EndDate]
        ,[src].[ExchangeRate]
    FROM
    (
        SELECT 
            CER.[CompanyID]
            ,CAST(GLS.[LCY Code] AS nvarchar(20)) AS [FromCurrency]
              ,CER.[Currency Code] AS [ToCurrency]
              ,CER.[Starting Date] + 1 AS [StartDate]
              ,CAST((CER.[Exchange Rate Amount] / CER.[Relational Exch_ Rate Amount]) AS decimal(18, 6)) AS [ExchangeRate]
        FROM [stg_navdb].[CurrencyExchangeRate] CER
        JOIN (SELECT [CompanyID],[LCY Code] FROM [stg_navdb].[GeneralLedgerSetup] UNION SELECT [CompanyID],[LCY Code] FROM [stg_bc].[GeneralLedgerSetup]) as GLS ON CER.CompanyID = GLS.CompanyID
        WHERE 0=0 AND ( CER.CompanyID IN(3,4) OR (CER.CompanyID IN(1,2) AND CER.[Starting Date] < '20230301') )
        
        UNION

        SELECT 
            CAST(CER.[CompanyID] as int) as [CompanyID]
             ,CAST(GLS.[LCY Code] AS nvarchar(20))  AS [FromCurrency]
              ,CER.[Currency Code] AS [ToCurrency]
              ,CER.[Starting Date] AS [StartDate]
              ,CAST((CER.[Exchange Rate Amount] / CER.[Relational Exch_ Rate Amount]) AS decimal(18, 6)) AS [ExchangeRate]
        FROM [stg_bc].[CurrencyExchangeRate] CER
        JOIN (SELECT [CompanyID],[LCY Code] FROM [stg_navdb].[GeneralLedgerSetup] UNION SELECT [CompanyID],[LCY Code] FROM [stg_bc].[GeneralLedgerSetup]) as GLS ON CER.CompanyID = GLS.CompanyID
        WHERE 0=0 AND [Starting Date] >= '20230301'
    ) AS [src]

    UNION 
    SELECT CAST(GLS.CompanyID as integer) as [CompanyID]
        ,CAST(GLS.[LCY Code] AS nvarchar(20)) AS [FromCurrency]
          ,CAST(GLS.[LCY Code] AS nvarchar(20)) AS [ToCurrency]
          ,DATETIMEFROMPARTS(2015, 10, 20, 0, 0, 0, 0) AS [StartDate]
          ,CAST(CAST(EOMONTH(GETDATE()) AS date) AS datetime) AS [EndDate]
          ,CAST(1 AS decimal(18, 6)) AS [ExchangeRate]
    FROM (SELECT [CompanyID],[LCY Code] FROM [stg_navdb].[GeneralLedgerSetup] UNION SELECT [CompanyID],[LCY Code] FROM [stg_bc].[GeneralLedgerSetup]) as GLS;

    INSERT INTO @Number
    (
        [Number]
    )
    SELECT TOP(1000)[n].[Number] - 1 AS [Number]
    FROM [utl].[Numbers] AS [n]
    ORDER BY [n].[Number];

    INSERT INTO @ExcangeRatesDate
    (
        [CompanyID]
        ,[FromCurrency]
        ,[ToCurrency]
        ,[DateKey]
        ,[ExchangeRate]
    )
    SELECT  [b].[CompanyID]
            ,[b].[FromCurrency]
            ,[b].[ToCurrency]
            ,YEAR([b].[StartDate]) * 10000 + MONTH([b].[StartDate]) * 100 + DAY([b].[StartDate]) AS DateKey
            ,[b].[ExchangeRate]
    FROM @base AS [b]

    INSERT INTO @Triangulated
    (   [CompanyID]
        ,[DateKey]
        ,[ToCurrency]
        ,[FromCurrency]
        ,[ExchangeRateTo]
        ,[ExchangeRateFrom]
    )
    SELECT 
    [CompanyID],
        [DateKey],
        [FromCurrency],
        [ToCurrency],
        [ExchangeRateFrom],
        [ExchangeRateTo]
    FROM (
    -- Exchange rates where the first currency is the FromCurrency
    SELECT 
        [CompanyID],
        [DateKey],
        [FromCurrency],
        [ToCurrency],
        [ExchangeRate] AS [ExchangeRateFrom],
        1 / [ExchangeRate] AS [ExchangeRateTo]
    FROM 
        @ExcangeRatesDate

    UNION
    -- Exchange rates where the second currency is the FromCurrency
    SELECT 
        [CompanyID],
        [DateKey],
        [ToCurrency] AS [FromCurrency],
        [FromCurrency] AS [ToCurrency],
        1 / [ExchangeRate] AS [ExchangeRateFrom],
        [ExchangeRate] AS [ExchangeRateTo]
    FROM 
        @ExcangeRatesDate
    ) as ExchangeRates;

    SELECT  [t].[CompanyID]
            ,[t].[DateKey]
            ,[t].[FromCurrency]
            ,[t].[ToCurrency]
            ,[t].[ExchangeRateFrom] AS [ExchangeRate]
            ,[t].ExchangeRateFrom AS [ExchangeRateFrom]
            ,[t].ExchangeRateTo AS [ExchangeRateTo]
    FROM @Triangulated AS [t]
    WHERE 0=0
    ORDER BY [t].[DateKey] ASC;
    --SELECT DISTINCT CompanyID, Count(CompanyID) FROM @Triangulated GROUP BY CompanyID

END;

GO

