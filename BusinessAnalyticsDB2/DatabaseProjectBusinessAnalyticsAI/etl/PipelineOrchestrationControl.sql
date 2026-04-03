CREATE TABLE [etl].[PipelineOrchestrationControl] (
    [ControlId] INT IDENTITY (1, 1) NOT NULL,
    [PipelineName] SYSNAME NOT NULL,
    [PipelineLayer] VARCHAR (20) NOT NULL,
    [ExecutionScope] VARCHAR (20) NOT NULL,
    [CountryCode] VARCHAR (10) NULL,
    [PhaseOrder] INT NOT NULL,
    [RunOrder] INT NOT NULL,
    [IsActive] BIT CONSTRAINT [DF_PipelineOrchestrationControl_IsActive] DEFAULT ((1)) NOT NULL,
    [StopOnFailure] BIT CONSTRAINT [DF_PipelineOrchestrationControl_StopOnFailure] DEFAULT ((1)) NOT NULL,
    [CreatedAtUtc] DATETIME2 (0) CONSTRAINT [DF_PipelineOrchestrationControl_CreatedAtUtc] DEFAULT (sysutcdatetime()) NOT NULL,
    [UpdatedAtUtc] DATETIME2 (0) CONSTRAINT [DF_PipelineOrchestrationControl_UpdatedAtUtc] DEFAULT (sysutcdatetime()) NOT NULL,
    CONSTRAINT [PK_PipelineOrchestrationControl] PRIMARY KEY CLUSTERED ([ControlId] ASC),
    CONSTRAINT [CK_PipelineOrchestrationControl_Country] CHECK ([ExecutionScope]='Country' AND [CountryCode] IS NOT NULL OR [ExecutionScope]='Global' AND [CountryCode] IS NULL),
    CONSTRAINT [CK_PipelineOrchestrationControl_Layer] CHECK ([PipelineLayer]='Fact' OR [PipelineLayer]='Dim' OR [PipelineLayer]='Stage'),
    CONSTRAINT [CK_PipelineOrchestrationControl_Scope] CHECK ([ExecutionScope]='Global' OR [ExecutionScope]='Country')
);

GO

CREATE UNIQUE NONCLUSTERED INDEX [UX_PipelineOrchestrationControl]
    ON [etl].[PipelineOrchestrationControl]([PipelineLayer] ASC, [ExecutionScope] ASC, [CountryCode] ASC, [PipelineName] ASC)

GO

CREATE NONCLUSTERED INDEX [IX_PipelineOrchestrationControl_ActiveOrder]
    ON [etl].[PipelineOrchestrationControl]([IsActive] ASC, [PhaseOrder] ASC, [RunOrder] ASC)

GO
