CREATE VIEW [etl].[Reports]
AS



SELECT 
	RH.[GlobalReportID],
	RH.[GlobalReportName],
	RH.[Description] as GlobalReportDescription,
	RL.[GlobalAccountNo],
	RL.[GlobalAccountDescription],
	RL.[LineNo],
	RL.[CompanyID],
    CMP.CompanyNameShort,
	RL.[CompanyGLAccountNo_],
	RL.[Name],
	RRB.[Description] as ResultBalance,
	RM.[Description] as Main,
	RFMG.[Description] as FMainGroup,
	RFMG1.[Description] as FMainGroup1,
	RFSG.[Description] as FSubGroup



FROM 
	etl.ReportHeader RH
	left join etl.ReportLines RL on RH.GlobalReportID = RL.GlobalReportHeaderID
	left join etl.ReportResBalance RRB on RL.Res_Balance_ID = RRB.ResBalanceID
	left join etl.ReportMain RM on RL.Main_ID = RM.MainID
	left join etl.ReportFMainGroup RFMG on RL.F_Main_Group_ID = RFMG.FMainGroupID
	left join etl.ReportFMainGroup1 RFMG1 on RL.F_Main_Group_1_ID = RFMG1.FMainGroup1
	left join etl.ReportFSubGroup RFSG on RL.F_Sub_Group_ID = RFSG.FSubGroupID
    left join etl.Company CMP on RL.CompanyID = CMP.CompanyId

GO

