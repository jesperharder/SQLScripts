Create View [PL_Item Extension] as
SELECT  [timestamp]
      ,[No_]
      ,[ABCD Category]
      ,[Item Brand]
      ,[Product Line Code]
      ,[Product Usage]
      ,[Prod_ Group Code]
      ,[Item Size]
      ,[Item Size Unit]
      ,[Item Feature]
      ,[Packing Method]
      ,[Coating]
      ,[Quality]
      ,[With Lid]
      ,[Weight Classification NOTO]
      ,[Calculated Available NOTO]
      ,[Calculated Available Ext_ NOTO]
      ,[Calculated Available Date NOTO]
      ,[PipelineName]
      ,[PipelineRunId]
      ,[PipelineTriggerTime]
      ,[CompanyID],
      CASE 
WHEN [Product Line Code] = 'CS+' THEN 'STEEL' 
WHEN [Product Line Code] = 'CX+' THEN 'STEEL' 
WHEN [Product Line Code] = 'CLASSIC PL' THEN 'ALU' 
WHEN [Product Line Code] = 'PRO S+' THEN 'ALU' 
WHEN [Product Line Code] = 'TECHNIQ' THEN 'ALU' 
WHEN [Product Line Code] = 'TECHNIQ IN' THEN 'ALU-INDUKTION' 
WHEN [Product Line Code] = 'CLASSIC' THEN 'ALU' 
WHEN [Product Line Code] = 'CLASSIC IN' THEN 'ALU-INDUKTION' 
WHEN [Product Line Code] = 'IQ' THEN 'ALU-INDUKTION' 
WHEN [Product Line Code] = 'CSX' THEN 'STEEL' 
WHEN [Product Line Code] = 'MAITRE D' THEN 'STEEL-POLER' 
WHEN [Product Line Code] = 'CTP' THEN 'STEEL-POLER' 
WHEN [Product Line Code] = 'CTQ' THEN 'STEEL' 
WHEN [Product Line Code] = 'CTX' THEN 'STEEL' 
WHEN [Product Line Code] = 'ERGONOMIC' THEN 'ALU' 
WHEN [Product Line Code] = 'EVOLUTION' THEN 'ALU' 
WHEN [Product Line Code] = 'PRO S+ IN' THEN 'ALU-INDUKTION' 
WHEN [Product Line Code] = 'INDU-PLUS' THEN 'ALU-INDUKTION' 
WHEN [Product Line Code] = 'HAPTIQ' THEN 'STEEL-POLER' 
WHEN [Product Line Code] = 'PRO IQ' THEN 'ALU-INDUKTION' 
WHEN [Product Line Code] = 'PRO S5' THEN 'ALU' 
WHEN [Product Line Code] = 'ES5' THEN 'ALU' 
WHEN [Product Line Code] = 'PRO WS' THEN 'ALU' 
WHEN [Product Line Code] = 'PLUS' THEN 'ALU' 
WHEN [Product Line Code] = 'RED' THEN 'ALU' 
WHEN [Product Line Code] = 'EXCLUSIVE' THEN 'ALU' 
WHEN [Product Line Code] = 'PROF' THEN 'ALU' 
WHEN [Product Line Code] = 'SPECTRUM' THEN 'ALU' 
WHEN [Product Line Code] = 'WS PRO SS'THEN 'STEEL' 
WHEN [Product Line Code] = 'CHEFS COLL' THEN 'ALU' 
ELSE 'Ukendt' 
END AS [Body Type]
  FROM [stg_bc].[ItemNotora]

GO

