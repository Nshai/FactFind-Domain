CREATE TABLE [dbo].[TPensionContributionStrategy]
(
[PensionContributionStrategyId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[Period] [nvarchar] (250)  NOT NULL,
[Percentage] [decimal] (5, 2) NULL,
[Details] [nvarchar] (250)  NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPensionContributionStrategy_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPensionContributionStrategy] ADD CONSTRAINT [PK_TPensionContributionStrategy] PRIMARY KEY NONCLUSTERED ([PensionContributionStrategyId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPensionContributionStrategy_PolicyBusinessId] ON [dbo].[TPensionContributionStrategy] ([PolicyBusinessId])
GO
ALTER TABLE [dbo].[TPensionContributionStrategy] WITH CHECK ADD CONSTRAINT [FK_TPensionContributionStrategy_PolicyBusinessId_PolicyBusinessId] FOREIGN KEY ([PolicyBusinessId]) REFERENCES [dbo].[TPolicyBusiness] ([PolicyBusinessId])
GO

