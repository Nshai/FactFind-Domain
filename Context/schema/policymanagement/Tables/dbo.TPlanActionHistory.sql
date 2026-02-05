CREATE TABLE [dbo].[TPlanActionHistory]
(
[PlanActionHistoryId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[RefPlanActionId] [int] NOT NULL,
[ChangedFrom] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ChangedTo] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[DateOfChange] [datetime] NOT NULL CONSTRAINT [DF_TPlanActionHistory_DateOfChange] DEFAULT (getdate()),
[ChangedByUserId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPlanActionHistory_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPlanActionHistory] ADD CONSTRAINT [PK_TPlanActionHistory] PRIMARY KEY NONCLUSTERED  ([PlanActionHistoryId]) WITH (FILLFACTOR=80)
GO
CREATE CLUSTERED INDEX [CIX_TPlanActionHistory_PolicyBusinessId] ON [dbo].[TPlanActionHistory] ([PolicyBusinessId])
GO
