CREATE TABLE [data_validation].[TablePair] (
    [TablePairId]       INT                IDENTITY (1, 1) NOT NULL,
    [ValidationCode]    NVARCHAR (128)     NOT NULL,
    [ValidationGroup]   NVARCHAR (20)      NOT NULL,
    [LeftSchemaName]    SYSNAME            NOT NULL,
    [LeftTableName]     SYSNAME            NOT NULL,
    [RightSchemaName]   SYSNAME            NOT NULL,
    [RightTableName]    SYSNAME            NOT NULL,
    [Description]       NVARCHAR (1000)    NULL,
    [IsActive]          BIT                CONSTRAINT [DF_data_validation_TablePair_IsActive] DEFAULT ((1)) NOT NULL,
    [CreatedAt]         DATETIMEOFFSET (7) CONSTRAINT [DF_data_validation_TablePair_CreatedAt] DEFAULT (SYSDATETIMEOFFSET()) NOT NULL,
    [UpdatedAt]         DATETIMEOFFSET (7) CONSTRAINT [DF_data_validation_TablePair_UpdatedAt] DEFAULT (SYSDATETIMEOFFSET()) NOT NULL,
    CONSTRAINT [PK_data_validation_TablePair] PRIMARY KEY CLUSTERED ([TablePairId] ASC),
    CONSTRAINT [UQ_data_validation_TablePair_ValidationCode] UNIQUE NONCLUSTERED ([ValidationCode] ASC)
);


GO
