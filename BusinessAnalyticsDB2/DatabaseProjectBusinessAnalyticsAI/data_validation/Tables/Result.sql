CREATE TABLE [data_validation].[Result] (
    [ResultId]          BIGINT           IDENTITY (1, 1) NOT NULL,
    [RunId]             BIGINT           NOT NULL,
    [RuleCode]          NVARCHAR (50)    NOT NULL,
    [ResultStatus]      NVARCHAR (20)    NOT NULL,
    [IssueCount]        BIGINT           CONSTRAINT [DF_data_validation_Result_IssueCount] DEFAULT ((0)) NOT NULL,
    [LeftMetricValue]   NVARCHAR (200)   NULL,
    [RightMetricValue]  NVARCHAR (200)   NULL,
    [SummaryText]       NVARCHAR (1000)  NULL,
    CONSTRAINT [PK_data_validation_Result] PRIMARY KEY CLUSTERED ([ResultId] ASC),
    CONSTRAINT [FK_data_validation_Result_Run] FOREIGN KEY ([RunId]) REFERENCES [data_validation].[Run] ([RunId]),
    CONSTRAINT [CK_data_validation_Result_ResultStatus] CHECK ([ResultStatus] IN (N'PASS', N'FAIL', N'ERROR'))
);


GO
