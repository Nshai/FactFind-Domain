CREATE TABLE [dbo].[TStatusHistory]
(
[StatusHistoryId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[StatusId] [int] NOT NULL,
[StatusReasonId] [int] NULL,
[ChangedToDate] [datetime] NOT NULL,
[ChangedByUserId] [int] NOT NULL,
[DateOfChange] [datetime] NULL,
[LifeCycleStepFG] [bit] NOT NULL CONSTRAINT [DF_TStatusHistory_LifeCycleStepFG] DEFAULT ((0)),
[CurrentStatusFG] [bit] NOT NULL CONSTRAINT [DF_TStatusHistory_CurrentStatusFG] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TStatusHistory_ConcurrencyId] DEFAULT ((1)),
[PlanMigrationRef] [varchar] (255)  NULL
)
GO
ALTER TABLE [dbo].[TStatusHistory] ADD CONSTRAINT [PK_TStatusHistory] PRIMARY KEY NONCLUSTERED  ([StatusHistoryId])
GO
CREATE NONCLUSTERED INDEX [IDX_TStatusHistory_CurrentStatusFG] ON [dbo].[TStatusHistory] ([CurrentStatusFG])
GO
CREATE NONCLUSTERED INDEX [IX_TStatusHistory_CurrentStatusFG] ON [dbo].[TStatusHistory] ([CurrentStatusFG]) INCLUDE ([PolicyBusinessId], [StatusId])
GO
CREATE NONCLUSTERED INDEX [IX_TStatusHistory_PlanMigrationRef] ON [dbo].[TStatusHistory] ([PlanMigrationRef])
GO
CREATE CLUSTERED INDEX [IDX1_TStatusHistory_PolicyBusinessId] ON [dbo].[TStatusHistory] ([PolicyBusinessId])
GO
CREATE NONCLUSTERED INDEX [IX_TStatusHistory_PolicyBusinessId_CurrentStatusFG] ON [dbo].[TStatusHistory] ([PolicyBusinessId], [CurrentStatusFG])
GO
CREATE NONCLUSTERED INDEX [IDX_TStatusHistory_StatusId] ON [dbo].[TStatusHistory] ([StatusId])
GO
CREATE NONCLUSTERED INDEX [IX_TStatusHistory_StatusId] ON [dbo].[TStatusHistory] ([StatusId]) INCLUDE ([PolicyBusinessId], [StatusHistoryId])
GO
CREATE NONCLUSTERED INDEX [IX_TStatusHistory_StatusId_CurrentStatusFG] ON [dbo].[TStatusHistory] ([StatusId], [CurrentStatusFG]) INCLUDE ([PolicyBusinessId],[ChangedToDate])
GO
CREATE NONCLUSTERED INDEX [IDX_TStatusHistory_StatusReasonId] ON [dbo].[TStatusHistory] ([StatusReasonId])
GO
ALTER TABLE [dbo].[TStatusHistory] WITH CHECK ADD CONSTRAINT [FK_TStatusHistory_PolicyBusinessId_PolicyBusinessId] FOREIGN KEY ([PolicyBusinessId]) REFERENCES [dbo].[TPolicyBusiness] ([PolicyBusinessId])
GO
ALTER TABLE [dbo].[TStatusHistory] WITH CHECK ADD CONSTRAINT [FK_TStatusHistory_StatusId_StatusId] FOREIGN KEY ([StatusId]) REFERENCES [dbo].[TStatus] ([StatusId])
GO
ALTER TABLE [dbo].[TStatusHistory] ADD CONSTRAINT [FK_TStatusHistory_StatusReasonId_StatusReasonId] FOREIGN KEY ([StatusReasonId]) REFERENCES [dbo].[TStatusReason] ([StatusReasonId])
GO
