
CREATE PROCEDURE [etl_v1].[GetRowsDimCampaign]
(
    @LastTimestamp nvarchar(24) = N'0x',
    @UpdateType int = 3
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ts varbinary(8) = CAST(RIGHT(@LastTimestamp, LEN(@LastTimestamp) - 2) AS varbinary(8));
    DECLARE @PostingFrom datetime = DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0));

    -- Campaign CTE
    WITH CampaignCompanyIDs AS (
        SELECT DISTINCT CompanyID as CampaignCompanyID
        FROM (
            SELECT CompanyID
            FROM stg_bc_api.Campaign
            UNION ALL
            SELECT CompanyID
            FROM stg_navdb.Campaign
        ) AS CombinedCompanies
    ),
    Campaigns AS (
        SELECT 
            CompanyID as CampaignCompanyID,
            [no] AS CampaignNo,
            [Description] AS CampaignDescription,
            CASE 
                WHEN [startingDate] = '1753-01-01 00:00:00.000' THEN NULL 
                ELSE CONVERT(DATE, [startingDate]) 
            END AS CampaignStartingDate,
            CASE 
                WHEN [endingDate] = '1753-01-01 00:00:00.000' THEN NULL 
                ELSE CONVERT(DATE, [endingDate]) 
            END AS CampaignEndingDate,
            CONCAT(
                CASE 
                    WHEN [startingDate] = '1753-01-01 00:00:00.000' THEN 'Open start date' 
                    ELSE CONVERT(VARCHAR(10), CONVERT(DATE, [startingDate]), 23) 
                END, 
                ' : ', 
                CASE 
                    WHEN [endingDate] = '1753-01-01 00:00:00.000' THEN 'Open ending date' 
                    ELSE CONVERT(VARCHAR(10), CONVERT(DATE, [endingDate]), 23) 
                END
            ) AS CampaignPeriod,
            [salespersonCode] AS CampaignSalespersonCode,
            [statusCode] AS CampaignStatusCode,
            'STG_BC_API' AS [SourceDB],
            ROW_NUMBER() OVER (PARTITION BY CompanyID, [no] ORDER BY (SELECT 1)) AS rn
        FROM stg_bc_api.Campaign

        UNION ALL

        SELECT 
            [CompanyID] as CampaignCompanyID,
            [No_] AS CampaignNo,
            [Description] AS CampaignDescription,
            CASE 
                WHEN [Starting Date] = '1753-01-01 00:00:00.000' THEN NULL 
                ELSE CONVERT(DATE, [Starting Date]) 
            END AS CampaignStartingDate,
            CASE 
                WHEN [Ending Date] = '1753-01-01 00:00:00.000' THEN NULL 
                ELSE CONVERT(DATE, [Ending Date]) 
            END AS CampaignEndingDate,
            CONCAT(
                CASE 
                    WHEN [Starting Date] = '1753-01-01 00:00:00.000' THEN 'Open start date' 
                    ELSE CONVERT(VARCHAR(10), CONVERT(DATE, [Starting Date]), 23) 
                END, 
                ' : ', 
                CASE 
                    WHEN [Ending Date] = '1753-01-01 00:00:00.000' THEN 'Open ending date' 
                    ELSE CONVERT(VARCHAR(10), CONVERT(DATE, [Ending Date]), 23) 
                END
            ) AS CampaignPeriod,
            [Salesperson Code] AS CampaignSalespersonCode,
            [Status Code] AS CampaignStatusCode,
            'STG_NAVDB' AS [SourceDB],
            ROW_NUMBER() OVER (PARTITION BY CompanyID, No_ ORDER BY (SELECT 1)) AS rn
        FROM stg_navdb.Campaign
    ),
    FilteredCampaigns AS (
        SELECT
            CampaignCompanyID,
            CampaignNo,
            CampaignDescription,
            CampaignStartingDate,
            CampaignEndingDate,
            CampaignPeriod,
            CampaignSalespersonCode,
            CampaignStatusCode,
            SourceDB
        FROM Campaigns
        WHERE rn = 1
    ),
    NoCampaignEntries AS (
        SELECT 
            c.CampaignCompanyID,
            'No Campaign' AS CampaignNo,
            'No Campaign' AS CampaignDescription,
            NULL AS CampaignStartingDate,
            NULL AS CampaignEndingDate,
            'No Campaign Period' AS CampaignPeriod,
            '' AS CampaignSalespersonCode,
            'No Status' AS CampaignStatusCode,
            'None' AS SourceDB
        FROM CampaignCompanyIDs c
        WHERE NOT EXISTS (
            SELECT 1 
            FROM FilteredCampaigns cmp 
            WHERE cmp.CampaignCompanyID = c.CampaignCompanyID
        )
    )

    -- Final Select
    SELECT
        CampaignCompanyID,
        CampaignNo,
        CampaignDescription,
        CampaignStartingDate,
        CampaignEndingDate,
        CampaignPeriod,
        CampaignSalespersonCode,
        CampaignStatusCode,
        SourceDB
    FROM FilteredCampaigns

    UNION ALL

    SELECT
        CampaignCompanyID,
        CampaignNo,
        CampaignDescription,
        CampaignStartingDate,
        CampaignEndingDate,
        CampaignPeriod,
        CampaignSalespersonCode,
        CampaignStatusCode,
        SourceDB
    FROM NoCampaignEntries
    ORDER BY CampaignCompanyID, CampaignNo;

END;

GO

