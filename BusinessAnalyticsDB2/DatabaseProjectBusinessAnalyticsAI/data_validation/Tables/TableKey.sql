CREATE TABLE [data_validation].[TableKey] (
    [TableKeyId]        INT             IDENTITY (1, 1) NOT NULL,
    [TablePairId]       INT             NOT NULL,
    [KeyOrdinal]        INT             NOT NULL,
    [KeyName]           NVARCHAR (100)  NOT NULL,
    [LeftExpression]    NVARCHAR (2000) NOT NULL,
    [RightExpression]   NVARCHAR (2000) NOT NULL,
    [KeyRole]           NVARCHAR (30)   NOT NULL,
    [IsActive]          BIT             CONSTRAINT [DF_data_validation_TableKey_IsActive] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_data_validation_TableKey] PRIMARY KEY CLUSTERED ([TableKeyId] ASC),
    CONSTRAINT [FK_data_validation_TableKey_TablePair] FOREIGN KEY ([TablePairId]) REFERENCES [data_validation].[TablePair] ([TablePairId]),
    CONSTRAINT [CK_data_validation_TableKey_KeyRole] CHECK ([KeyRole] IN (N'PARTITION', N'BUSINESS', N'AUXILIARY')),
    CONSTRAINT [UQ_data_validation_TableKey_TablePair_KeyOrdinal] UNIQUE NONCLUSTERED ([TablePairId] ASC, [KeyOrdinal] ASC)
);


GO
