CREATE TABLE [data_validation].[CompanyScope] (
    [CompanyScopeId]  INT             IDENTITY (1, 1) NOT NULL,
    [TablePairId]     INT             NOT NULL,
    [CompanyId]       NVARCHAR (100)  NOT NULL,
    [ScopeType]       NVARCHAR (20)   NOT NULL,
    [IsActive]        BIT             CONSTRAINT [DF_data_validation_CompanyScope_IsActive] DEFAULT ((1)) NOT NULL,
    [Note]            NVARCHAR (500)  NULL,
    CONSTRAINT [PK_data_validation_CompanyScope] PRIMARY KEY CLUSTERED ([CompanyScopeId] ASC),
    CONSTRAINT [FK_data_validation_CompanyScope_TablePair] FOREIGN KEY ([TablePairId]) REFERENCES [data_validation].[TablePair] ([TablePairId]),
    CONSTRAINT [CK_data_validation_CompanyScope_ScopeType] CHECK ([ScopeType] IN (N'INCLUDE', N'EXCLUDE')),
    CONSTRAINT [UQ_data_validation_CompanyScope_TablePair_Company_ScopeType] UNIQUE NONCLUSTERED ([TablePairId] ASC, [CompanyId] ASC, [ScopeType] ASC)
);


GO
