CREATE TABLE [stg_navdb].[DefaultDimension] (
    [timestamp]              VARBINARY (8)  NULL,
    [Table ID]               INT            NULL,
    [No_]                    VARCHAR (20)   NULL,
    [Dimension Code]         VARCHAR (20)   NULL,
    [Dimension Value Code]   VARCHAR (20)   NULL,
    [Value Posting]          INT            NULL,
    [Multi Selection Action] INT            NULL,
    [PipelineName]           NVARCHAR (MAX) NULL,
    [PipelineRunId]          NVARCHAR (MAX) NULL,
    [PipelineTriggerTime]    NVARCHAR (MAX) NULL,
    [CompanyID]              NVARCHAR (MAX) NULL
);


GO

