CREATE TABLE [dim].[GeneralBusinessPostingGroup] (
    [GeneralBusinessPostingGroupKey]      INT            NOT NULL,
    [CompanyID]                           INT            NOT NULL,
    [GeneralBusinessPostingGroupCode]     NVARCHAR (20)  NOT NULL,
    [GeneralBusinessPostingGroupName]     NVARCHAR (100) NOT NULL,
    [GeneralBusinessPostingGroupCodeName] NVARCHAR (123) NOT NULL,
    [GeneralBusinessPostingGroupHashKey]  NVARCHAR (200) NULL,
    [ADF_BatchId_Insert]                  BIGINT         CONSTRAINT [DF_dim_GeneralBusinessPostingGroup_InsertBacthId] DEFAULT ((0)) NOT NULL,
    [ADF_BatchId_Update]                  BIGINT         CONSTRAINT [DF_dim_GeneralBusinessPostingGroup_UpdateBacthId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_GeneralBusinessPostingGroup] PRIMARY KEY CLUSTERED ([GeneralBusinessPostingGroupKey] ASC) WITH (DATA_COMPRESSION = ROW),
    CONSTRAINT [UQ_GeneralBusinessPostingGroup] UNIQUE NONCLUSTERED ([CompanyID] ASC, [GeneralBusinessPostingGroupCode] ASC) WITH (DATA_COMPRESSION = ROW)
);


GO

EXECUTE sp_addextendedproperty @name = N'UnknownEntityName', @value = N'GeneralBusinessPostingGroup', @level0type = N'SCHEMA', @level0name = N'dim', @level1type = N'TABLE', @level1name = N'GeneralBusinessPostingGroup';


GO

