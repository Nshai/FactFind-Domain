CREATE TABLE [dbo].[TPlanActionHistoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PlanActionHistoryId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[RefPlanActionId] [int] NOT NULL,
[ChangedFrom] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ChangedTo] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[DateOfChange] [datetime] NOT NULL CONSTRAINT [DF_TPlanActionHistoryAudit_DateOfChange] DEFAULT (getdate()),
[ChangedByUserId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPlanActionHistoryAudit_ConcurrencyId] DEFAULT ((1)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPlanActionHistoryAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPlanActionHistoryAudit] ADD CONSTRAINT [PK_TPlanActionHistoryAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TPlanActionHistoryAudit_PlanActionHistoryId_ConcurrencyId] ON [dbo].[TPlanActionHistoryAudit] ([PlanActionHistoryId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
