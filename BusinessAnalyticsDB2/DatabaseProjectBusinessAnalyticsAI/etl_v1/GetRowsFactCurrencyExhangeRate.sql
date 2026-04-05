CREATE PROCEDURE [etl_v1].[GetRowsFactCurrencyExhangeRate]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @base TABLE
    (
        [CompanyID] INT NOT NULL,
        [FromCurrency] NVARCHAR(20) NOT NULL,
        [ToCurrency] NVARCHAR(20) NOT NULL,
        [StartDate] DATETIME NOT NULL,
        [EndDate] DATETIME NOT NULL,
        [ExchangeRate] DECIMAL(18, 6) NOT NULL,
        PRIMARY KEY CLUSTERED
        (
            [CompanyID] ASC,
            [FromCurrency] ASC,
            [ToCurrency] ASC,
            [StartDate] ASC,
            [EndDate] ASC
        )
    );

    DECLARE @ExchangeRatesDate TABLE
    (
        [CompanyID] INT NOT NULL,
        [FromCurrency] NVARCHAR(20) NOT NULL,
        [ToCurrency] NVARCHAR(20) NOT NULL,
        [DateKey] INT NOT NULL,
        [ExchangeRate] DECIMAL(18, 6) NOT NULL,
        PRIMARY KEY CLUSTERED
        (
            [CompanyID] ASC,
            [FromCurrency] ASC,
            [ToCurrency] ASC,
            [DateKey] ASC
        ),
        INDEX [IX_ExchangeRatesDate_FromCurrency_DateKey_WithIncluded] NONCLUSTERED
        (
            [CompanyID] ASC,
            [FromCurrency] ASC,
            [DateKey] ASC
        )
        INCLUDE([ExchangeRate])
    );

    DECLARE @Triangulated TABLE
    (
        [CompanyID] INT NOT NULL,
        [DateKey] INT NOT NULL,
        [ToCurrency] NVARCHAR(20) NOT NULL,
        [FromCurrency] NVARCHAR(20) NOT NULL,
        [ExchangeRateTo] DECIMAL(18, 6) NOT NULL,
        [ExchangeRateFrom] DECIMAL(18, 6) NOT NULL
    );

    INSERT INTO @base
    (
        [CompanyID],
        [FromCurrency],
        [ToCurrency],
        [StartDate],
        [EndDate],
        [ExchangeRate]
    )
    SELECT
        [src].[CompanyID],
        [src].[FromCurrency],
        [src].[ToCurrency],
        [src].[StartDate],
        ISNULL(
            DATEADD(
                DAY,
                -1,
                LEAD([src].[StartDate], 1) OVER (
                    PARTITION BY [src].[CompanyID], [src].[FromCurrency], [src].[ToCurrency]
                    ORDER BY [src].[CompanyID], [src].[StartDate]
                )
            ),
            CAST(CAST(EOMONTH(GETDATE()) AS DATE) AS DATETIME)
        ) AS [EndDate],
        [src].[ExchangeRate]
    FROM
    (
        SELECT
            [cer].[CompanyID],
            CAST([gls].[LCY Code] AS NVARCHAR(20)) AS [FromCurrency],
            [cer].[Currency Code] AS [ToCurrency],
            [cer].[Starting Date] + 1 AS [StartDate],
            CAST(([cer].[Exchange Rate Amount] / [cer].[Relational Exch_ Rate Amount]) AS DECIMAL(18, 6)) AS [ExchangeRate]
        FROM [stg_navdb].[CurrencyExchangeRate] AS [cer]
        INNER JOIN
        (
            SELECT [CompanyID], [LCY Code]
            FROM [stg_navdb].[GeneralLedgerSetup]

            UNION

            SELECT [CompanyId] AS [CompanyID], [lcyCode] AS [LCY Code]
            FROM [stg_bc_api].[GeneralLedgerSetup]
        ) AS [gls]
            ON [cer].[CompanyID] = [gls].[CompanyID]
        WHERE
            [cer].[CompanyID] IN (3, 4)
            OR ([cer].[CompanyID] IN (1, 2) AND [cer].[Starting Date] < '20230301')

        UNION

        SELECT
            [cer].[CompanyId] AS [CompanyID],
            CAST([gls].[LCY Code] AS NVARCHAR(20)) AS [FromCurrency],
            [cer].[currencyCode] AS [ToCurrency],
            CAST([cer].[startingDate] AS DATETIME) AS [StartDate],
            CAST(([cer].[exchangeRateAmount] / [cer].[relationalExchRateAmount]) AS DECIMAL(18, 6)) AS [ExchangeRate]
        FROM [stg_bc_api].[CurrencyExchangeRate] AS [cer]
        INNER JOIN
        (
            SELECT [CompanyID], [LCY Code]
            FROM [stg_navdb].[GeneralLedgerSetup]

            UNION

            SELECT [CompanyId] AS [CompanyID], [lcyCode] AS [LCY Code]
            FROM [stg_bc_api].[GeneralLedgerSetup]
        ) AS [gls]
            ON [cer].[CompanyId] = [gls].[CompanyID]
        WHERE
            ([cer].[CompanyId] IN (1, 2) AND [cer].[startingDate] >= '20230301')
            OR [cer].[CompanyId] NOT IN (1, 2)
    ) AS [src]

    UNION

    SELECT
        CAST([gls].[CompanyID] AS INT) AS [CompanyID],
        CAST([gls].[LCY Code] AS NVARCHAR(20)) AS [FromCurrency],
        CAST([gls].[LCY Code] AS NVARCHAR(20)) AS [ToCurrency],
        DATETIMEFROMPARTS(2015, 10, 20, 0, 0, 0, 0) AS [StartDate],
        CAST(CAST(EOMONTH(GETDATE()) AS DATE) AS DATETIME) AS [EndDate],
        CAST(1 AS DECIMAL(18, 6)) AS [ExchangeRate]
    FROM
    (
        SELECT [CompanyID], [LCY Code]
        FROM [stg_navdb].[GeneralLedgerSetup]

        UNION

        SELECT [CompanyId] AS [CompanyID], [lcyCode] AS [LCY Code]
        FROM [stg_bc_api].[GeneralLedgerSetup]
    ) AS [gls];

    INSERT INTO @ExchangeRatesDate
    (
        [CompanyID],
        [FromCurrency],
        [ToCurrency],
        [DateKey],
        [ExchangeRate]
    )
    SELECT
        [b].[CompanyID],
        [b].[FromCurrency],
        [b].[ToCurrency],
        YEAR([b].[StartDate]) * 10000 + MONTH([b].[StartDate]) * 100 + DAY([b].[StartDate]) AS [DateKey],
        [b].[ExchangeRate]
    FROM @base AS [b];

    INSERT INTO @Triangulated
    (
        [CompanyID],
        [DateKey],
        [ToCurrency],
        [FromCurrency],
        [ExchangeRateTo],
        [ExchangeRateFrom]
    )
    SELECT
        [CompanyID],
        [DateKey],
        [FromCurrency],
        [ToCurrency],
        [ExchangeRateFrom],
        [ExchangeRateTo]
    FROM
    (
        SELECT
            [CompanyID],
            [DateKey],
            [FromCurrency],
            [ToCurrency],
            [ExchangeRate] AS [ExchangeRateFrom],
            1 / [ExchangeRate] AS [ExchangeRateTo]
        FROM @ExchangeRatesDate

        UNION

        SELECT
            [CompanyID],
            [DateKey],
            [ToCurrency] AS [FromCurrency],
            [FromCurrency] AS [ToCurrency],
            1 / [ExchangeRate] AS [ExchangeRateFrom],
            [ExchangeRate] AS [ExchangeRateTo]
        FROM @ExchangeRatesDate
    ) AS [ExchangeRates];

    SELECT
        [t].[CompanyID],
        [t].[DateKey],
        [t].[FromCurrency],
        [t].[ToCurrency],
        [t].[ExchangeRateFrom] AS [ExchangeRate],
        [t].[ExchangeRateFrom],
        [t].[ExchangeRateTo]
    FROM @Triangulated AS [t]
    ORDER BY
        [t].[DateKey] ASC,
        [t].[CompanyID] ASC,
        [t].[FromCurrency] ASC,
        [t].[ToCurrency] ASC;
END;


GO
