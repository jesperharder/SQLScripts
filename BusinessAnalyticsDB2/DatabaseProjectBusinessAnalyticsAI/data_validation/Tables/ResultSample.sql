CREATE TABLE [data_validation].[ResultSample] (
    [ResultSampleId]  BIGINT          IDENTITY (1, 1) NOT NULL,
    [ResultId]        BIGINT          NOT NULL,
    [SampleType]      NVARCHAR (50)   NOT NULL,
    [CompanyId]       NVARCHAR (100)  NULL,
    [BusinessKey]     NVARCHAR (500)  NULL,
    [LeftValue]       NVARCHAR (1000) NULL,
    [RightValue]      NVARCHAR (1000) NULL,
    [Details]         NVARCHAR (MAX)  NULL,
    CONSTRAINT [PK_data_validation_ResultSample] PRIMARY KEY CLUSTERED ([ResultSampleId] ASC),
    CONSTRAINT [FK_data_validation_ResultSample_Result] FOREIGN KEY ([ResultId]) REFERENCES [data_validation].[Result] ([ResultId])
);


GO
