CREATE TABLE [dbo].[TMoneyPurchasePensionPlanFFExtAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[Employer] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[LumpSumCommutation] [money] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMoneyPurchasePensionPlanFFExtAudit_ConcurrencyId] DEFAULT ((1)),
[MoneyPurchasePensionPlanFFExtId] [int] NOT NULL,
[StampAction] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NOT NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL
)
GO
ALTER TABLE [dbo].[TMoneyPurchasePensionPlanFFExtAudit] ADD CONSTRAINT [PK_TMoneyPurchasePensionPlanFFExtAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TMoneyPurchasePensionPlanFFExtAudit_MoneyPurchasePensionPlanFFExtId_ConcurrencyId] ON [dbo].[TMoneyPurchasePensionPlanFFExtAudit] ([MoneyPurchasePensionPlanFFExtId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
