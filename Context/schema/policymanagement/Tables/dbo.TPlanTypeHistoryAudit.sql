CREATE TABLE [dbo].[TPlanTypeHistoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[RefPlanType2ProdSubTypeId] [int] NOT NULL,
[DateOfChange] [datetime] NOT NULL CONSTRAINT [DF_TPlanTypeHistoryAudit_DateOfChange] DEFAULT (getdate()),
[ChangedByUserId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPlanTypeHistoryAudit_ConcurrencyId] DEFAULT ((1)),
[PlanTypeHistoryId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPlanTypeHistoryAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPlanTypeHistoryAudit] ADD CONSTRAINT [PK_TPlanTypeHistoryAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TPlanTypeHistoryAudit_PlanTypeHistoryId_ConcurrencyId] ON [dbo].[TPlanTypeHistoryAudit] ([PlanTypeHistoryId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
