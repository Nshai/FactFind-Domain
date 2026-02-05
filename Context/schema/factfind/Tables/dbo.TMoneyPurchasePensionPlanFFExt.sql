CREATE TABLE [dbo].[TMoneyPurchasePensionPlanFFExt]
(
[MoneyPurchasePensionPlanFFExtId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[Employer] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[LumpSumCommutation] [money] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMoneyPurchasePensionPlanFFExt_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TMoneyPurchasePensionPlanFFExt] ADD CONSTRAINT [PK_TMoneyPurchasePensionPlanFFExt] PRIMARY KEY NONCLUSTERED  ([MoneyPurchasePensionPlanFFExtId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_INCL_TMoneyPurchasePensionPlanFFExt_PolicyBusinessId] ON [dbo].[TMoneyPurchasePensionPlanFFExt] ([PolicyBusinessId]) INCLUDE ([Employer])
GO
