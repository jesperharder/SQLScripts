
CREATE   VIEW [etl].[BC_TransferLine]
AS
WITH [dates]
AS
(
    SELECT DATETIMEFROMPARTS(1753, 1, 1, 0, 0, 0, 0) AS [NullDate]
          ,DATETIMEFROMPARTS(1900, 1, 1, 0, 0, 0, 0) AS [BOT]
)
SELECT [src].[DW_SK_Date_Shipment]
      ,IIF([src].[BK_CurrentExpectedArrival] = [src].[BOT], -1, YEAR([src].[BK_CurrentExpectedArrival]) * 10000 + MONTH([src].[BK_CurrentExpectedArrival]) * 100 + DAY([src].[BK_CurrentExpectedArrival])) AS [DW_SK_Date_CurrentExpectedArrival]
      ,IIF([src].[PostingDate] = [src].[BOT], -1, YEAR([src].[PostingDate]) * 10000 + MONTH([src].[PostingDate]) * 100 + DAY([src].[PostingDate])) AS [DW_SK_Date_Posting]
      ,CAST([src].[PostingDate] AS datetime) AS [NK_PostingDate]
      ,[src].[BK_TransferFromCode]
	  ,[src].[BK_TransferToCode]
      ,[src].[BK_ItemNumber]
      ,[src].[BK_TransferDocumentNumber]
      ,[src].[BK_TransferDocumentLineNumber]
      ,[src].[BK_InTransitCode]
      ,[src].[BK_CurrencyCode_Company]
      ,[src].[M_Quantity]
      ,[src].[M_OutstandingQuantity]
      ,[src].[M_QtyToReceive]
      ,[src].[CompanyID]
      ,[src].[NK_TransferOrderNumber]
      ,[src].[NK_TransferOrderLineNumber]
      ,[src].[ADF_LastTimestamp]
      ,[src].[ADF_FactSource]
      ,[src].[AD HOC]
      ,[src].[AFDELING]
      ,[src].[KÆDE]
      ,[src].[LAND]
      ,[src].[LEVERANDØR]
      ,[src].[MARKEDSF]
      ,[src].[PERSONALE]
      ,[src].[VEDLIGEH]
FROM
(
    SELECT YEAR([ph].[Shipment Date]) * 10000 + MONTH([ph].[Shipment Date]) * 100 + DAY([ph].[Shipment Date]) AS [DW_SK_Date_Shipment]
          ,[ph].[Shipment Date] AS [DateShipment]
          ,CASE
               WHEN [pl].[Shipment Date] = [ds].[NullDate] THEN
                   [ds].[BOT]
               ELSE
                   CONVERT(date
                          ,ISNULL(NULLIF(   CASE
                                                WHEN [pl].[Receipt Date] = [ds].[NullDate] THEN
                                                    [pl].[Receipt Date]
                                                ELSE
                                                    [pl].[Receipt Date]
                                            END
                                           ,[ds].[NullDate]
                                        )
                                 ,[ds].[BOT]
                                 )
                          )
           END AS [BK_CurrentExpectedArrival]
          ,CONVERT(date
                  ,ISNULL(NULLIF(   CASE
                                        WHEN [ph].[Posting Date] = [ds].[NullDate]
                                        AND  [pl].[Receipt Date] = [ds].[NullDate] THEN
                                            [pl].[Receipt Date]
                                        WHEN [ph].[Posting Date] = [ds].[NullDate] THEN
                                            [pl].[Receipt Date]
                                        ELSE
                                            [ph].[Posting Date]
                                    END
                                   ,[ds].[NullDate]
                                )
                         ,[ds].[BOT]
                         )
                  ) AS [PostingDate]
          ,[ph].[Transfer-from Code] AS [BK_TransferFromCode]
		  ,[ph].[Transfer-to Code] AS [BK_TransferToCode]
          ,NULLIF([pl].[Item No_], N'') AS [BK_ItemNumber]
          ,[ph].[No_] AS [BK_TransferDocumentNumber]
          ,[pl].[Line No_] AS [BK_TransferDocumentLineNumber]
          ,ISNULL(NULLIF([pl].[In-Transit Code], N''), [ph].[In-Transit Code]) AS [BK_InTransitCode]
          ,[gls].[LCY Code] AS [BK_CurrencyCode_Company]
          ,[dims].[AD HOC]
          ,[dims].[AFDELING]
          ,[dims].[KÆDE]
          ,[dims].[LAND]
          ,[dims].[LEVERANDØR]
          ,[dims].[MARKEDSF]
          ,[dims].[PERSONALE]
          ,[dims].[VEDLIGEH]
          ,[pl].[Quantity] AS [M_Quantity]
          ,[pl].[Outstanding Quantity] AS [M_OutstandingQuantity]
          ,[pl].[Qty_ to Receive] AS [M_QtyToReceive]
          ,[pl].[CompanyID]
          ,[pl].[Document No_] AS [NK_TransferOrderNumber]
          ,[pl].[Line No_] AS [NK_TransferOrderLineNumber]
          ,MAX([gls].[timestamp]) OVER () AS [ADF_LastTimestamp]
          ,N'BC_TransferLine' AS [ADF_FactSource]
          ,[ds].[NullDate]
          ,[ds].[BOT]
    FROM [stg_bc].[TransferLine] AS [pl]
    INNER JOIN [stg_bc].[TransferHeader] AS [ph]
    ON  [ph].[No_] = [pl].[Document No_]
    AND [ph].[CompanyID] = [pl].[CompanyID]
    INNER JOIN [stg_bc].[GeneralLedgerSetup] AS [gls]
    ON [gls].[CompanyID] = [pl].[CompanyID]
    CROSS JOIN [dates] AS [ds]
    OUTER APPLY
    (
        SELECT [Dimension Set ID]
              ,[CompanyID]
              ,[AD HOC]
              ,[AFDELING]
              ,[KÆDE]
              ,[LAND]
              ,[LEVERANDØR]
              ,[MARKEDSF.] AS [MARKEDSF]
              ,[PERSONALE]
              ,[VEDLIGEH.] AS [VEDLIGEH]
        FROM
        (
            SELECT [dse].[Dimension Set ID]
                  ,[dse].[Dimension Code]
                  ,[dse].[Dimension Value Code]
                  ,[dse].[CompanyID]
            FROM [stg_bc].[DimensionSetEntry] AS [dse]
            WHERE [dse].[Dimension Set ID] = [pl].[Dimension Set ID]
            AND   [dse].[CompanyID] = [pl].[CompanyID]
        ) AS [scr]
        PIVOT
        (
            MAX([Dimension Value Code])
            FOR [Dimension Code] IN([AD HOC], [AFDELING], [KÆDE], [LAND], [LEVERANDØR], [MARKEDSF.], [PERSONALE], [VEDLIGEH.])
        ) AS [pvt]
    ) AS [dims]
) AS [src];

GO

