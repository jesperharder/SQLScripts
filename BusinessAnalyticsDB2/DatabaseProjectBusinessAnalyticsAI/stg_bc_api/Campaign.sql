CREATE TABLE [stg_bc_api].[Campaign] (
    [CompanyId]               INT                NOT NULL,
    [no]                      NVARCHAR (20)      NOT NULL,
    [description]             NVARCHAR (100)     NULL,
    [startingDate]            DATETIMEOFFSET (7) NULL,
    [endingDate]              DATETIMEOFFSET (7) NULL,
    [lastDateModified]        DATETIMEOFFSET (7) NULL,
    [salespersonCode]         NVARCHAR (20)      NULL,
    [noSeries]                NVARCHAR (20)      NULL,
    [globalDimension1Code]    NVARCHAR (20)      NULL,
    [globalDimension2Code]    NVARCHAR (20)      NULL,
    [statusCode]              NVARCHAR (10)      NULL,
    [hasComment]              BIT                NULL,
    [targetContactsContacted] INT                NULL,
    [contactsResponded]       INT                NULL,
    [durationMin]             DECIMAL (38, 20)   NULL,
    [costLCY]                 DECIMAL (38, 20)   NULL,
    [noOfOpportunities]       INT                NULL,
    [estimatedValueLCY]       DECIMAL (38, 20)   NULL,
    [calcdCurrentValueLCY]    DECIMAL (38, 20)   NULL,
    [activated]               BIT                NULL,
    [systemId]                UNIQUEIDENTIFIER   NOT NULL,
    [systemCreatedAt]         DATETIMEOFFSET (7) NULL,
    [systemCreatedBy]         UNIQUEIDENTIFIER   NULL,
    [systemModifiedAt]        DATETIMEOFFSET (7) NULL,
    [systemModifiedBy]        UNIQUEIDENTIFIER   NULL,
    [PipelineName]            NVARCHAR (200)     NULL,
    [PipelineRunId]           NVARCHAR (100)     NULL,
    [PipelineTriggerTime]     DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_Campaign] PRIMARY KEY CLUSTERED ([CompanyId] ASC, [no] ASC)
);


GO

