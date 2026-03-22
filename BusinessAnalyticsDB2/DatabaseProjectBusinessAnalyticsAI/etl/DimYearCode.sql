CREATE view [etl].[DimYearCode] as

select distinct
    [YearCodeCompanyID]
    ,isnull(trim([YearCodeText]),'') as [YearCodeText] 
    ,isnull(trim(CONVERT(VARCHAR, YM.IntervalFrom, 105)),'') as [YearCodeFromDate]
    ,isnull(trim(CONVERT(VARCHAR, YM.IntervalTo, 105)),'') as [YearCodeToDate]
from (
select distinct
    CompanyID as [YearCodeCompanyID]
    ,[YearCode Text] as [YearCodeText]
    ,cast(null as nvarchar(30)) as [YearCodeFromDate]
    ,cast(null as nvarchar(30)) as [YearCodeToDate]
from stg_bc.SalesInvoiceLine
UNION
select distinct
    CompanyID as [YearCodeCompanyID]
    ,[YearCode Text] as [YearCodeText]
    ,cast(null as nvarchar(30)) as [YearCodeFromDate]
    ,cast(null as nvarchar(30)) as [YearCodeToDate]
from stg_bc.SalesCrMemoLine
UNION
select distinct
    CompanyID as [YearCodeCompanyID]
    ,[YearCode Text] as [YearCodeText]
    ,cast(null as nvarchar(30)) as [YearCodeFromDate]
    ,cast(null as nvarchar(30)) as [YearCodeToDate]
from stg_navdb.SalesInvoiceLine
UNION
select distinct
    CompanyID as [YearCodeCompanyID]
    ,[YearCode Text] as [YearCodeText]
    ,cast(null as nvarchar(30)) as [YearCodeFromDate]
    ,cast(null as nvarchar(30)) as [YearCodeToDate]
from stg_navdb.SalesCrMemoLine
) as YearCodes
left join [etl].[YearCodeLookupMaster] YM on YearCodes.YearCodeCompanyID = 1 and trim(YearCodes.[YearCodeText]) = trim(YM.Code)

GO

