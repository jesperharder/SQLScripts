CREATE VIEW [etl_v1].[BC_TransferLine]
AS
SELECT
    CASE
        WHEN [ph].[shipmentDate] IS NULL THEN -1
        ELSE YEAR([ph].[shipmentDate]) * 10000 + MONTH([ph].[shipmentDate]) * 100 + DAY([ph].[shipmentDate])
    END AS [DW_SK_Date_Shipment],
    CASE
        WHEN ISNULL([pl].[receiptDate], [ph].[receiptDate]) IS NULL THEN -1
        ELSE YEAR(ISNULL([pl].[receiptDate], [ph].[receiptDate])) * 10000 + MONTH(ISNULL([pl].[receiptDate], [ph].[receiptDate])) * 100 + DAY(ISNULL([pl].[receiptDate], [ph].[receiptDate]))
    END AS [DW_SK_Date_CurrentExpectedArrival],
    CASE
        WHEN ISNULL([ph].[postingDate], [pl].[receiptDate]) IS NULL THEN -1
        ELSE YEAR(ISNULL([ph].[postingDate], [pl].[receiptDate])) * 10000 + MONTH(ISNULL([ph].[postingDate], [pl].[receiptDate])) * 100 + DAY(ISNULL([ph].[postingDate], [pl].[receiptDate]))
    END AS [DW_SK_Date_Posting],
    CONVERT(datetime, ISNULL([ph].[postingDate], ISNULL([pl].[receiptDate], '19000101'))) AS [NK_PostingDate],
    [ph].[transferFromCode] AS [BK_TransferFromCode],
    [ph].[transferToCode] AS [BK_TransferToCode],
    NULLIF([pl].[itemNo], N'') AS [BK_ItemNumber],
    [ph].[no] AS [BK_TransferDocumentNumber],
    [pl].[lineNo] AS [BK_TransferDocumentLineNumber],
    ISNULL(NULLIF([pl].[inTransitCode], N''), [ph].[inTransitCode]) AS [BK_InTransitCode],
    [gls].[lcyCode] AS [BK_CurrencyCode_Company],
    [pl].[quantity] AS [M_Quantity],
    [pl].[outstandingQuantity] AS [M_OutstandingQuantity],
    [pl].[qtyToReceive] AS [M_QtyToReceive],
    [pl].[CompanyId] AS [CompanyID],
    [pl].[documentNo] AS [NK_TransferOrderNumber],
    [pl].[lineNo] AS [NK_TransferOrderLineNumber],
    CONVERT(varbinary(8), 0) AS [ADF_LastTimestamp],
    N'BC_TransferLine' AS [ADF_FactSource],
    CONVERT(datetime2(7), ISNULL([pl].[systemModifiedAt], ISNULL([ph].[systemModifiedAt], '19000101'))) AS [ADF_SourceModifiedAt],
    [dims].[AD HOC],
    [dims].[AFDELING],
    [dims].[KÆDE],
    [dims].[LAND],
    [dims].[LEVERANDØR],
    [dims].[MARKEDSF],
    [dims].[PERSONALE],
    [dims].[VEDLIGEH]
FROM [stg_bc_api].[TransferLine] AS [pl]
INNER JOIN [stg_bc_api].[TransferHeader] AS [ph]
    ON [ph].[CompanyId] = [pl].[CompanyId]
   AND [ph].[no] = [pl].[documentNo]
INNER JOIN [stg_bc_api].[GeneralLedgerSetup] AS [gls]
    ON [gls].[CompanyId] = [pl].[CompanyId]
OUTER APPLY
(
    SELECT
        MAX(CASE WHEN [dse].[dimensionCode] = N'AD HOC' THEN [dse].[dimensionValueCode] END) AS [AD HOC],
        MAX(CASE WHEN [dse].[dimensionCode] = N'AFDELING' THEN [dse].[dimensionValueCode] END) AS [AFDELING],
        MAX(CASE WHEN [dse].[dimensionCode] = N'KÆDE' THEN [dse].[dimensionValueCode] END) AS [KÆDE],
        MAX(CASE WHEN [dse].[dimensionCode] = N'LAND' THEN [dse].[dimensionValueCode] END) AS [LAND],
        MAX(CASE WHEN [dse].[dimensionCode] = N'LEVERANDØR' THEN [dse].[dimensionValueCode] END) AS [LEVERANDØR],
        MAX(CASE WHEN [dse].[dimensionCode] = N'MARKEDSF.' THEN [dse].[dimensionValueCode] END) AS [MARKEDSF],
        MAX(CASE WHEN [dse].[dimensionCode] = N'PERSONALE' THEN [dse].[dimensionValueCode] END) AS [PERSONALE],
        MAX(CASE WHEN [dse].[dimensionCode] = N'VEDLIGEH.' THEN [dse].[dimensionValueCode] END) AS [VEDLIGEH]
    FROM [stg_bc_api].[DimensionSetEntry] AS [dse]
    WHERE [dse].[dimensionSetId] = ISNULL(NULLIF([pl].[dimensionSetId], 0), NULLIF([ph].[dimensionSetId], 0))
      AND [dse].[CompanyId] = [pl].[CompanyId]
) AS [dims];

GO
