CREATE TABLE [dbo].[TFinancialPlanningLock]
(
[FinancialPlanningLockId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[LockDate] [datetime] NOT NULL CONSTRAINT [DF_TFinancialPlanningLock_LockDate] DEFAULT (getdate()),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningLock_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFinancialPlanningLock] ADD CONSTRAINT [PK_TFinancialPlanningLock] PRIMARY KEY NONCLUSTERED  ([FinancialPlanningLockId])
GO
CREATE NONCLUSTERED INDEX [IdxFinancialPlanningLock_FinancialPlanningId] ON [dbo].[TFinancialPlanningLock] ([FinancialPlanningId])
GO
