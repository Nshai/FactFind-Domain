CREATE TABLE [dbo].[TLifeCycleTransition]
(
[LifeCycleTransitionId] [int] NOT NULL IDENTITY(1, 1),
[LifeCycleStepId] [int] NOT NULL,
[ToLifeCycleStepId] [int] NOT NULL,
[OrderNumber] [int] NULL,
[Type] [varchar] (150)  NULL,
[HideStep] [bit] NOT NULL CONSTRAINT [DF_TLifeCycleTransition_HideStep] DEFAULT ((0)),
[AddToCommissionsFg] [tinyint] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLifeCycleTransition_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TLifeCycleTransition] ADD CONSTRAINT [PK_TLifeCycleTransition] PRIMARY KEY NONCLUSTERED  ([LifeCycleTransitionId])
GO
CREATE NONCLUSTERED INDEX [IDX_TLifeCycleTransition_LifeCycleStepId] ON [dbo].[TLifeCycleTransition] ([LifeCycleStepId])
GO
CREATE NONCLUSTERED INDEX [IDX_TLifeCycleTransition_ToLifeCycleStepId] ON [dbo].[TLifeCycleTransition] ([ToLifeCycleStepId])
GO
ALTER TABLE [dbo].[TLifeCycleTransition] WITH CHECK ADD CONSTRAINT [FK_TLifeCycleTransition_LifeCycleStepId_LifeCycleStepId] FOREIGN KEY ([LifeCycleStepId]) REFERENCES [dbo].[TLifeCycleStep] ([LifeCycleStepId])
GO
ALTER TABLE [dbo].[TLifeCycleTransition] WITH CHECK ADD CONSTRAINT [FK_TLifeCycleTransition_ToLifeCycleStepId_LifeCycleStepId] FOREIGN KEY ([ToLifeCycleStepId]) REFERENCES [dbo].[TLifeCycleStep] ([LifeCycleStepId])
GO
