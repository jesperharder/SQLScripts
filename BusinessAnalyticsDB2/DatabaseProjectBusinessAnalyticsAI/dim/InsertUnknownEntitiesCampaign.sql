
CREATE PROCEDURE [dim].[InsertUnknownEntitiesCampaign]
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Get the current transaction count
        DECLARE @TranCounter INT = @@TRANCOUNT,
                @SavePoint NVARCHAR(32) = CAST(@@PROCID AS NVARCHAR(20)) + N'_' + CAST(@@NESTLEVEL AS NVARCHAR(2));

        -- Decide to join existing transaction or start new
        IF @TranCounter > 0
            SAVE TRANSACTION @SavePoint;
        ELSE
            BEGIN TRANSACTION;

        -- Merge operation to insert unknown entities into the dim.Campaign table
        MERGE [dim].[Campaign] AS d
        USING (
            SELECT 
                -1 AS CampaignCompanyID,
                -1 AS CampaignKey,
                'Unknown' AS CampaignNo,
                'Unknown' AS CampaignDescription,
                NULL AS CampaignStartingDate,
                NULL AS CampaignEndingDate,
                'Open start date : Open ending date' AS CampaignPeriod,
                'Unknown' AS CampaignSalespersonCode,
                'Unknown' AS CampaignStatusCode,
                'None' AS SourceDB

            UNION ALL

            SELECT 
                -2 AS CampaignCompanyID,
                -2 AS CampaignKey,
                'Blank' AS CampaignNo,
                'Blank' AS CampaignDescription,
                NULL AS CampaignStartingDate,
                NULL AS CampaignEndingDate,
                'No Campaign Period' AS CampaignPeriod,
                'Blank' AS CampaignSalespersonCode,
                'No Status' AS CampaignStatusCode,
                'None' AS SourceDB
        ) AS s
        ON d.CampaignKey = s.CampaignKey


        WHEN NOT MATCHED THEN
            INSERT (CampaignCompanyID, CampaignKey, CampaignNo, CampaignDescription, CampaignStartingDate, CampaignEndingDate, CampaignPeriod, CampaignSalespersonCode, CampaignStatusCode, SourceDB)
            VALUES (s.CampaignCompanyID, s.CampaignKey ,s.CampaignNo, s.CampaignDescription, s.CampaignStartingDate, s.CampaignEndingDate, s.CampaignPeriod, s.CampaignSalespersonCode, s.CampaignStatusCode, s.SourceDB)
        WHEN MATCHED THEN
            UPDATE SET
                d.CampaignDescription = s.CampaignDescription,
                d.CampaignStartingDate = s.CampaignStartingDate,
                d.CampaignEndingDate = s.CampaignEndingDate,
                d.CampaignPeriod = s.CampaignPeriod,
                d.CampaignSalespersonCode = s.CampaignSalespersonCode,
                d.CampaignStatusCode = s.CampaignStatusCode,
                d.SourceDB = s.SourceDB
        OPTION (RECOMPILE);

        -- Commit only if the transaction was started in this procedure
        IF @TranCounter = 0
            COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback transaction if started in this procedure
        IF @TranCounter = 0
            ROLLBACK TRANSACTION;
        ELSE
            IF XACT_STATE() = 1
                ROLLBACK TRANSACTION @SavePoint;
            ELSE IF XACT_STATE() = -1
                ROLLBACK TRANSACTION;

        THROW;
        RETURN 1;
    END CATCH;
END

GO

