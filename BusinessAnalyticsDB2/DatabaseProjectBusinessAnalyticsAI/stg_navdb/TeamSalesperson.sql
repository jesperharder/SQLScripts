CREATE TABLE [stg_navdb].[TeamSalesperson] (
    [CompanyID]           TINYINT            NOT NULL,
    [timestamp]           VARBINARY (8)      NOT NULL,
    [Team Code]           VARCHAR (10)       NOT NULL,
    [Salesperson Code]    VARCHAR (10)       NOT NULL,
    [PipelineName]        NVARCHAR (128)     NULL,
    [PipelineRunId]       NVARCHAR (36)      NULL,
    [PipelineTriggerTime] DATETIMEOFFSET (0) NULL,
    CONSTRAINT [PK_stg_navdb_TeamSalesperson] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [Team Code] ASC, [Salesperson Code] ASC)
);


GO

CREATE NONCLUSTERED INDEX [ix_stg_navdb_TeamSalesperson_timestamp]
    ON [stg_navdb].[TeamSalesperson]([CompanyID] ASC, [timestamp] ASC);


GO

