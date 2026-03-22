CREATE TABLE [stg_bc].[VendorNotora] (
    [timestamp]           VARBINARY (8)      NOT NULL,
    [No_]                 NVARCHAR (20)      NOT NULL,
    [Old Vendor No_]      NVARCHAR (20)      NOT NULL,
    [PipelineName]        NVARCHAR (200)     CONSTRAINT [DF_VendorNotora_PipelineName] DEFAULT ('Default') NOT NULL,
    [PipelineRunId]       NVARCHAR (36)      CONSTRAINT [DF_VendorNotora_PipelineRunId] DEFAULT ('00000000-0000-0000-0000-000000000000') NOT NULL,
    [PipelineTriggerTime] DATETIMEOFFSET (0) CONSTRAINT [DF_VendorNotora_PipelineTriggerTime] DEFAULT (sysdatetimeoffset()) NOT NULL,
    [CompanyID]           INT                NOT NULL,
    CONSTRAINT [PK_stg_bc_VendorNotora] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [No_] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

