CREATE   VIEW [etl].[BC_PurchaseLine]
AS
WITH [dates]
AS
(
    SELECT DATETIMEFROMPARTS(1753, 1, 1, 0, 0, 0, 0) AS [NullDate]
          ,DATETIMEFROMPARTS(1900, 1, 1, 0, 0, 0, 0) AS [BOT]
)
SELECT [src].[DW_SK_Date_Order]
      ,IIF([src].[BK_CurrentExpectedArrival] = [src].[BOT], -1, YEAR([src].[BK_CurrentExpectedArrival]) * 10000 + MONTH([src].[BK_CurrentExpectedArrival]) * 100 + DAY([src].[BK_CurrentExpectedArrival])) AS [DW_SK_Date_CurrentExpectedArrival]
      ,IIF([src].[PostingDate] = [src].[BOT], -1, YEAR([src].[PostingDate]) * 10000 + MONTH([src].[PostingDate]) * 100 + DAY([src].[PostingDate])) AS [DW_SK_Date_Posting]
      ,[src].[DW_SK_Date_Document]
      ,CAST([src].[PostingDate] AS datetime) AS [NK_PostingDate]
      ,[src].[BK_VendorNumber]
      ,[src].[BK_ItemNumber]
      ,[src].[BK_PurchaseDocumentNumber]
      ,[src].[BK_PurchaseDocumentLineNumber]
      ,[src].[BK_LocationCode]
      ,[src].[BK_CurrencyCode_Document]
      ,[src].[BK_CurrencyCode_Company]
      ,[src].[LineTypeNumber]
      ,[src].[M_Quantity]
      ,[src].[M_OutstandingQuantity]
      ,[src].[M_QtyToReceive]
      ,[src].[M_UnitCost]
      ,[src].[M_DirectUnitCost]
      ,[src].[M_UnitCost_LCY]
      ,[src].[M_UnitPrice_LCY]
      ,[src].[M_OutstandingAmount]
      ,[src].[M_OutstandingAmount_LCY]
      ,[src].[M_ReceivedNotInvoicedQuantity]
      ,[src].[M_ReceivedNotInvoicedAmount]
      ,[src].[CompanyID]
      ,[src].[NK_PurchaseOrderNumber]
      ,[src].[NK_PurchaseOrderLineNumber]
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
    SELECT YEAR([ph].[Order Date]) * 10000 + MONTH([ph].[Order Date]) * 100 + DAY([ph].[Order Date]) AS [DW_SK_Date_Order]
          ,[ph].[Order Date] AS [DateOrder]
          ,CASE
               WHEN [pl].[Order Date] = [ds].[NullDate] THEN
                   [ds].[BOT]
               ELSE
                   CONVERT(date
                          ,ISNULL(NULLIF(   CASE
                                                WHEN [pl].[Expected Receipt Date] = [ds].[NullDate] THEN
                                                    [pl].[Requested Receipt Date]
                                                ELSE
                                                    [pl].[Expected Receipt Date]
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
                                        AND  [pl].[Expected Receipt Date] = [ds].[NullDate] THEN
                                            [pl].[Requested Receipt Date]
                                        WHEN [ph].[Posting Date] = [ds].[NullDate] THEN
                                            [pl].[Expected Receipt Date]
                                        ELSE
                                            [ph].[Posting Date]
                                    END
                                   ,[ds].[NullDate]
                                )
                         ,[ds].[BOT]
                         )
                  ) AS [PostingDate]
          ,YEAR([ph].[Document Date]) * 10000 + MONTH([ph].[Document Date]) * 100 + DAY([ph].[Document Date]) AS [DW_SK_Date_Document]
          ,[ph].[Buy-from Vendor No_] AS [BK_VendorNumber]
          ,NULLIF([pl].[No_], N'') AS [BK_ItemNumber]
          ,[ph].[No_] AS [BK_PurchaseDocumentNumber]
          ,[pl].[Line No_] AS [BK_PurchaseDocumentLineNumber]
          ,ISNULL(NULLIF([pl].[Location Code], N''), [ph].[Location Code]) AS [BK_LocationCode]
          ,ISNULL(NULLIF([ph].[Currency Code], ''), [gls].[LCY Code]) AS [BK_CurrencyCode_Document]
          ,[gls].[LCY Code] AS [BK_CurrencyCode_Company]
          ,[dims].[AD HOC]
          ,[dims].[AFDELING]
          ,[dims].[KÆDE]
          ,[dims].[LAND]
          ,[dims].[LEVERANDØR]
          ,[dims].[MARKEDSF]
          ,[dims].[PERSONALE]
          ,[dims].[VEDLIGEH]
          ,[pl].[Type] AS [LineTypeNumber]
          ,[pl].[Quantity] AS [M_Quantity]
          ,[pl].[Outstanding Quantity] AS [M_OutstandingQuantity]
          ,[pl].[Qty_ to Receive] AS [M_QtyToReceive]
          ,[pl].[Unit Cost] AS [M_UnitCost]
          ,[pl].[Direct Unit Cost] AS [M_DirectUnitCost]
          ,[pl].[Unit Cost (LCY)] AS [M_UnitCost_LCY]
          ,[pl].[Unit Price (LCY)] AS [M_UnitPrice_LCY]
          ,[pl].[Outstanding Amount] AS [M_OutstandingAmount]
          ,[pl].[Outstanding Amount (LCY)] AS [M_OutstandingAmount_LCY]
          ,[pl].[Qty_ Rcd_ Not Invoiced] AS [M_ReceivedNotInvoicedQuantity]
          ,[pl].[Amt_ Rcd_ Not Invoiced (LCY)] AS [M_ReceivedNotInvoicedAmount]
          ,[pl].[CompanyID]
          ,[pl].[Document No_] AS [NK_PurchaseOrderNumber]
          ,[pl].[Line No_] AS [NK_PurchaseOrderLineNumber]
          ,MAX([gls].[timestamp]) OVER () AS [ADF_LastTimestamp]
          ,N'BC_PurchaseLine' AS [ADF_FactSource]
          ,[ds].[NullDate]
          ,[ds].[BOT]
    FROM [stg_bc].[PurchaseLine] AS [pl]
    INNER JOIN [stg_bc].[PurchaseHeader] AS [ph]
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

