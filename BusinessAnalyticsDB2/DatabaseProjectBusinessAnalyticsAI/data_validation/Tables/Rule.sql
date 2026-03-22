CREATE TABLE [data_validation].[Rule] (
    [RuleId]           INT            IDENTITY (1, 1) NOT NULL,
    [TablePairId]      INT            NOT NULL,
    [RuleCode]         NVARCHAR (50)  NOT NULL,
    [Severity]         NVARCHAR (20)  CONSTRAINT [DF_data_validation_Rule_Severity] DEFAULT (N'ERROR') NOT NULL,
    [SampleLimit]      INT            CONSTRAINT [DF_data_validation_Rule_SampleLimit] DEFAULT ((100)) NOT NULL,
    [IsActive]         BIT            CONSTRAINT [DF_data_validation_Rule_IsActive] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_data_validation_Rule] PRIMARY KEY CLUSTERED ([RuleId] ASC),
    CONSTRAINT [FK_data_validation_Rule_TablePair] FOREIGN KEY ([TablePairId]) REFERENCES [data_validation].[TablePair] ([TablePairId]),
    CONSTRAINT [CK_data_validation_Rule_RuleCode] CHECK ([RuleCode] IN
    (
        N'TABLE_EXISTS',
        N'ROWCOUNT_TOTAL',
        N'ROWCOUNT_BY_COMPANY',
        N'DISTINCT_KEYCOUNT_BY_COMPANY',
        N'DUPLICATE_KEYS_LEFT',
        N'DUPLICATE_KEYS_RIGHT',
        N'MISSING_IN_RIGHT',
        N'MISSING_IN_LEFT'
    )),
    CONSTRAINT [UQ_data_validation_Rule_TablePair_RuleCode] UNIQUE NONCLUSTERED ([TablePairId] ASC, [RuleCode] ASC)
);


GO
