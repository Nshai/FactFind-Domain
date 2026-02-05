CREATE TABLE [dbo].[TValExcludedPlan]
(
[ValExcludedPlanId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[PolicyBusinessId] [int] NOT NULL,
[RefProdProviderId] [int] NOT NULL,
[ExcludedByUserId] [int] NULL,
[ExcludedDate] [datetime] NOT NULL CONSTRAINT [DF_TValExcludedPlan_ExcludedDate] DEFAULT (getdate()),
[EmailAlertSent] [bit] NOT NULL CONSTRAINT [DF_TValExcludedPlan_EmailAlertSent] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValExcludedPlan_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TValExcludedPlan] ADD CONSTRAINT [PK_TValExcludedPlan] PRIMARY KEY NONCLUSTERED  ([ValExcludedPlanId])
GO
CREATE NONCLUSTERED INDEX [idx_TValExcludedPlan_PolicyBusinessId] ON [dbo].[TValExcludedPlan] ([PolicyBusinessId])
GO
