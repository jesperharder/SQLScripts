CREATE TABLE [stg_navdb].[LedgerEntryDimension] (
    [timestamp]            VARBINARY (8)      NOT NULL,
    [CompanyID]            INT                NOT NULL,
    [Table ID]             INT                NOT NULL,
    [Entry No_]            INT                NOT NULL,
    [Dimension Code]       VARCHAR (20)       NOT NULL,
    [Dimension Value Code] VARCHAR (20)       NOT NULL,
    [PipelineName]         NVARCHAR (128)     NULL,
    [PipelineRunId]        NVARCHAR (36)      NULL,
    [PipelineTriggerTime]  DATETIMEOFFSET (0) NULL,
    CONSTRAINT [stgLedgerEntryDimension] PRIMARY KEY CLUSTERED ([CompanyID] ASC, [Table ID] ASC, [Entry No_] ASC, [Dimension Code] ASC)
);


GO

CREATE NONCLUSTERED INDEX [NCI_stg_navdb_LedgerEntryDimension_TableID_DimensionCode_WithIncluded]
    ON [stg_navdb].[LedgerEntryDimension]([Table ID] ASC, [Dimension Code] ASC)
    INCLUDE([Dimension Value Code]) WITH (DATA_COMPRESSION = ROW);


GO

CREATE NONCLUSTERED INDEX [NIX_stg_navdb_LedgerEntryDimension_CompanyID_TableID_DimensionCode_WithIncluded]
    ON [stg_navdb].[LedgerEntryDimension]([CompanyID] ASC, [Table ID] ASC, [Dimension Code] ASC)
    INCLUDE([Dimension Value Code]) WITH (DATA_COMPRESSION = ROW);


GO

CREATE NONCLUSTERED INDEX [ix_stg_navdb_LedgerEntryDimension_TableID_EntryNo_DimensionCode]
    ON [stg_navdb].[LedgerEntryDimension]([CompanyID] ASC, [Table ID] ASC, [Entry No_] ASC, [Dimension Code] ASC)
    INCLUDE([Dimension Value Code]);


GO

CREATE NONCLUSTERED INDEX [ix_stg_stg_navdb_LedgerEntryDimension_timestamp]
    ON [stg_navdb].[LedgerEntryDimension]([CompanyID] ASC, [timestamp] ASC);


GO

CREATE UNIQUE NONCLUSTERED INDEX [stg_navdb_LedgerEntryDimension]
    ON [stg_navdb].[LedgerEntryDimension]([timestamp] ASC, [CompanyID] ASC);


GO

