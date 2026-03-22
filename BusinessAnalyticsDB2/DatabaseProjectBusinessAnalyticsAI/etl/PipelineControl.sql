CREATE TABLE [etl].[PipelineControl] (
    [CountryCode]  NVARCHAR (10)  NULL,
    [PipelineName] NVARCHAR (200) NULL,
    [IsActive]     BIT            NULL,
    [RunOrder]     INT            NULL
);


GO

