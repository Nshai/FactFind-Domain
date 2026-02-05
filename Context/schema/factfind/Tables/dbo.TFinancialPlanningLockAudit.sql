CREATE TABLE [dbo].[TFinancialPlanningLockAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[LockDate] [datetime] NOT NULL CONSTRAINT [DF_TFinancialPlanningLockAudit_LockDate] DEFAULT (getdate()),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningLockAudit_ConcurrencyId] DEFAULT ((1)),
[FinancialPlanningLockId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFinancialPlanningLockAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFinancialPlanningLockAudit] ADD CONSTRAINT [PK_TFinancialPlanningLockAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFinancialPlanningLockAudit_FinancialPlanningLockId_ConcurrencyId] ON [dbo].[TFinancialPlanningLockAudit] ([FinancialPlanningLockId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
