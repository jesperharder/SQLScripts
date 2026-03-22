CREATE TABLE [stg_bc].[Team] (
    [timestamp]           VARBINARY (8)  NULL,
    [Code]                NVARCHAR (10)  NULL,
    [Name]                NVARCHAR (50)  NULL,
    [PipelineName]        NVARCHAR (MAX) NULL,
    [PipelineRunId]       NVARCHAR (MAX) NULL,
    [PipelineTriggerTime] NVARCHAR (MAX) NULL,
    [CompanyID]           NVARCHAR (MAX) NULL
);


GO

