CREATE TABLE [stg_navdb].[Team] (
    [timestamp]           VARBINARY (8)  NULL,
    [Code]                VARCHAR (10)   NULL,
    [Name]                VARCHAR (30)   NULL,
    [PipelineName]        NVARCHAR (MAX) NULL,
    [PipelineRunId]       NVARCHAR (MAX) NULL,
    [PipelineTriggerTime] NVARCHAR (MAX) NULL,
    [CompanyID]           NVARCHAR (MAX) NULL
);


GO

