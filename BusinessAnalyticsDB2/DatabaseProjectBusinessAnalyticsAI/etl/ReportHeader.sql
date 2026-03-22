CREATE TABLE [etl].[ReportHeader] (
    [GlobalReportID]   INT           NOT NULL,
    [GlobalReportName] NVARCHAR (50) NOT NULL,
    [Description]      NVARCHAR (50) NOT NULL,
    [CreatedDate]      DATETIME      NULL,
    [ChangedDate]      DATETIME      NULL,
    CONSTRAINT [PK_ReportHeader_ID] PRIMARY KEY CLUSTERED ([GlobalReportID] ASC)
);


GO

CREATE TRIGGER [etl].[trg_ReportHeader_UpdateTrigger]
ON [etl].[ReportHeader]
AFTER UPDATE
AS
BEGIN
    UPDATE [etl].[ReportHeader]
    SET [ChangedDate] = GETDATE()
    WHERE [GlobalReportID] IN
          (
              SELECT DISTINCT [Inserted].[GlobalReportID] FROM [Inserted]
          );
END;

GO

CREATE TRIGGER [etl].[trg_ReportHeader_InsertTrigger]
ON [etl].[ReportHeader]
AFTER INSERT
AS
BEGIN
    UPDATE [etl].[ReportHeader]
    SET [ChangedDate] = GETDATE()
       ,[CreatedDate] = GETDATE()
    WHERE [GlobalReportID] IN
          (
              SELECT DISTINCT [Inserted].[GlobalReportID] FROM [Inserted]
          );
END;

GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Report Headers for GlobalReports', @level0type = N'SCHEMA', @level0name = N'etl', @level1type = N'TABLE', @level1name = N'ReportHeader';


GO

