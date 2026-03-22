CREATE VIEW [fct].[GLEntry_Source]
AS
    SELECT
        [gle].[CompanyID],
        [gle].[Entry No_],
        [gle].[G_L Account No_],
        [gle].[Posting Date],
        [gle].[Amount],
        [dims].[AFDELING],
        [dims].[KÆDE],
        [dims].[LAND],
        [dims].[LEVERANDØR],
        [dims].[MARKEDSF],
        [dims].[PERSONALE],
        [dims].[VEDLIGEH]
    FROM [stg_bc].[GLEntry] AS [gle]
    OUTER APPLY ( 
                    SELECT  [Dimension Set ID],
                            [CompanyID],
                            [AFDELING],
                            [KÆDE],
                            [LAND],
                            [LEVERANDØR],
                            [MARKEDSF.] AS [MARKEDSF],
                            [PERSONALE],
                            [VEDLIGEH.] AS [VEDLIGEH]
                    FROM (
                            SELECT [Dimension Set ID]
                                , [Dimension Code]
                                , [Dimension Value Code]
                                , [CompanyID]
                            FROM [stg_bc].[DimensionSetEntry] AS [dse]
                            WHERE [dse].[Dimension Set ID] = [gle].[Dimension Set ID]
                            AND [dse].[CompanyID] = [gle].[CompanyID]
                        ) AS [scr]
                    PIVOT (MAX([Dimension Value Code])
                    FOR [Dimension Code] IN ([AFDELING], [KÆDE], [LAND], [LEVERANDØR], [MARKEDSF.], [PERSONALE], [VEDLIGEH.] )) AS [pvt]
    ) AS [dims]

GO

