CREATE TABLE [data_validation].[Run] (
    [RunId]            BIGINT             IDENTITY (1, 1) NOT NULL,
    [TablePairId]      INT                NOT NULL,
    [ValidationCode]   NVARCHAR (128)     NOT NULL,
    [StartedAt]        DATETIMEOFFSET (7) CONSTRAINT [DF_data_validation_Run_StartedAt] DEFAULT (SYSDATETIMEOFFSET()) NOT NULL,
    [FinishedAt]       DATETIMEOFFSET (7) NULL,
    [ExecutionStatus]  NVARCHAR (20)      CONSTRAINT [DF_data_validation_Run_ExecutionStatus] DEFAULT (N'RUNNING') NOT NULL,
    [ExecutedBy]       NVARCHAR (200)     NULL,
    [Message]          NVARCHAR (MAX)     NULL,
    CONSTRAINT [PK_data_validation_Run] PRIMARY KEY CLUSTERED ([RunId] ASC),
    CONSTRAINT [FK_data_validation_Run_TablePair] FOREIGN KEY ([TablePairId]) REFERENCES [data_validation].[TablePair] ([TablePairId]),
    CONSTRAINT [CK_data_validation_Run_ExecutionStatus] CHECK ([ExecutionStatus] IN (N'RUNNING', N'PASSED', N'FAILED', N'ERROR'))
);


GO
