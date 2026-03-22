CREATE TABLE [dim_v1].[GeneralProductPostingGroup] (
    [GeneralProductPostingGroupKey]      INT            NOT NULL,
    [CompanyID]                          INT            NOT NULL,
    [GeneralProductPostingGroupCode]     NVARCHAR (20)  NOT NULL,
    [GeneralProductPostingGroupName]     NVARCHAR (100) NOT NULL,
    [GeneralProductPostingGroupCodeName] NVARCHAR (123) NOT NULL,
    [GeneralProductPostingGroupHashKey]  NVARCHAR (200) NULL,
    [ADF_BatchId_Insert]                 BIGINT         CONSTRAINT [DF_dim_GeneralProductPostingGroup_InsertBacthId] DEFAULT ((0)) NOT NULL,
    [ADF_BatchId_Update]                 BIGINT         CONSTRAINT [DF_dim_GeneralProductPostingGroup_UpdateBacthId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_GeneralProductPostingGroup] PRIMARY KEY CLUSTERED ([GeneralProductPostingGroupKey] ASC),
    CONSTRAINT [UQ_GeneralProductPostingGroup] UNIQUE NONCLUSTERED ([CompanyID] ASC, [GeneralProductPostingGroupCode] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'UnknownEntityName', @value = N'GeneralProductPostingGroup', @level0type = N'SCHEMA', @level0name = N'dim_v1', @level1type = N'TABLE', @level1name = N'GeneralProductPostingGroup';


GO

