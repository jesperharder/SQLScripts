CREATE TABLE [etl].[ReportLines] (
    [GlobalReportHeaderID]     INT           NOT NULL,
    [GlobalAccountNo]          NVARCHAR (50) NOT NULL,
    [GlobalAccountDescription] NVARCHAR (50) NOT NULL,
    [LineNo]                   INT           NOT NULL,
    [CompanyID]                INT           NOT NULL,
    [CompanyGLAccountNo_]      NVARCHAR (50) NOT NULL,
    [Name]                     NVARCHAR (50) NOT NULL,
    [Res_Balance_ID]           INT           NOT NULL,
    [Main_ID]                  INT           NOT NULL,
    [F_Main_Group_ID]          INT           NOT NULL,
    [F_Main_Group_1_ID]        INT           NOT NULL,
    [F_Sub_Group_ID]           INT           NOT NULL,
    [CreatedDate]              DATETIME      NULL,
    [ChangedDate]              DATETIME      NULL,
    CONSTRAINT [PK_ReportLines] PRIMARY KEY CLUSTERED ([GlobalReportHeaderID] ASC, [GlobalAccountNo] ASC, [LineNo] ASC)
);


GO

CREATE TRIGGER [etl].[trg_ReportLines_UpdateTrigger]
ON [etl].[ReportLines]
AFTER INSERT
AS
BEGIN
    UPDATE [etl].[ReportLines]
    SET [ChangedDate] = GETDATE() --, CreatedDate = GETDATE()
    WHERE [GlobalReportHeaderID] IN
          (
              SELECT DISTINCT [Inserted].[GlobalReportHeaderID] FROM [Inserted]
          );

END;

GO

CREATE TRIGGER [etl].[trg_ReportLines_InsertTrigger]
ON [etl].[ReportLines]
AFTER INSERT
AS
BEGIN
    UPDATE [etl].[ReportLines]
    SET [ChangedDate] = GETDATE()
       ,[CreatedDate] = GETDATE()
    WHERE [GlobalReportHeaderID] IN
          (
              SELECT DISTINCT [Inserted].[GlobalReportHeaderID] FROM [Inserted]
          );

END;

GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Contains all Global ReportLines', @level0type = N'SCHEMA', @level0name = N'etl', @level1type = N'TABLE', @level1name = N'ReportLines';


GO

