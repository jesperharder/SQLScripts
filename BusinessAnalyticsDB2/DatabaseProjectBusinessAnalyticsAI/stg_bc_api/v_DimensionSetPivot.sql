CREATE VIEW stg_bc_api.v_DimensionSetPivot AS
SELECT
  dse.CompanyID,
  dse.DimensionSetID,
  MAX(CASE WHEN DimensionCode='AFDELING'  THEN DimensionValueCode END) AS AFDELING,
  MAX(CASE WHEN DimensionCode='KÆDE'      THEN DimensionValueCode END) AS KÆDE,
  MAX(CASE WHEN DimensionCode='LAND'      THEN DimensionValueCode END) AS LAND,
  MAX(CASE WHEN DimensionCode='LEVERANDØR' THEN DimensionValueCode END) AS LEVERANDØR,
  MAX(CASE WHEN DimensionCode='MARKEDSF.' THEN DimensionValueCode END) AS MARKEDSF,
  MAX(CASE WHEN DimensionCode='PERSONALE' THEN DimensionValueCode END) AS PERSONALE,
  MAX(CASE WHEN DimensionCode='VEDLIGEH.' THEN DimensionValueCode END) AS VEDLIGEH
FROM stg_bc_api.DimensionSetEntry dse
GROUP BY dse.CompanyID, dse.DimensionSetID;

GO

