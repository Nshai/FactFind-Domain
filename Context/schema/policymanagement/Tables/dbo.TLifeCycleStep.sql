CREATE TABLE [dbo].[TLifeCycleStep]
(
[LifeCycleStepId] [int] NOT NULL IDENTITY(1, 1),
[StatusId] [int] NOT NULL,
[LifeCycleId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLifeCycleStep_ConcurrencyId] DEFAULT ((1)),
[IsSystem] [bit] NOT NULL CONSTRAINT [DF_TLifeCycleStep_IsSystem] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TLifeCycleStep] ADD CONSTRAINT [PK_TLifeCycleStep] PRIMARY KEY NONCLUSTERED  ([LifeCycleStepId])
GO
CREATE NONCLUSTERED INDEX [IDX_TLifeCycleStep_LifeCycleId] ON [dbo].[TLifeCycleStep] ([LifeCycleId]) INCLUDE ([ConcurrencyId], [LifeCycleStepId], [StatusId])
GO
CREATE CLUSTERED INDEX [IDX_TLifeCycleStep_LifeCycleStepId] ON [dbo].[TLifeCycleStep] ([LifeCycleStepId])
GO
CREATE NONCLUSTERED INDEX [IDX_TLifeCycleStep_StatusId] ON [dbo].[TLifeCycleStep] ([StatusId])
GO
ALTER TABLE [dbo].[TLifeCycleStep] WITH CHECK ADD CONSTRAINT [FK_TLifeCycleStep_LifeCycleId_LifeCycleId] FOREIGN KEY ([LifeCycleId]) REFERENCES [dbo].[TLifeCycle] ([LifeCycleId])
GO
ALTER TABLE [dbo].[TLifeCycleStep] WITH CHECK ADD CONSTRAINT [FK_TLifeCycleStep_StatusId_StatusId] FOREIGN KEY ([StatusId]) REFERENCES [dbo].[TStatus] ([StatusId])
GO
