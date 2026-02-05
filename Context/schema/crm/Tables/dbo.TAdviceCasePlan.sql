CREATE TABLE [dbo].[TAdviceCasePlan]
(
[AdviceCasePlanId] [int] NOT NULL IDENTITY(1, 1),
[AdviceCaseId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviceCasePlan_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAdviceCasePlan] ADD CONSTRAINT [PK_TAdviceCasePlan] PRIMARY KEY CLUSTERED  ([AdviceCasePlanId])
GO
CREATE NONCLUSTERED INDEX IX_TAdviceCasePlan_PolicyBusinessId ON [dbo].[TAdviceCasePlan] ([PolicyBusinessId])
GO
CREATE NONCLUSTERED INDEX IX_TAdviceCasePlan_AdviceCaseId ON [dbo].[TAdviceCasePlan] ([AdviceCaseId])
GO