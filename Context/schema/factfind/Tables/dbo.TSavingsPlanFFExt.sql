CREATE TABLE [dbo].[TSavingsPlanFFExt]
(
[SavingsPlanFFExtId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[InterestRate] [money] NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
CREATE NONCLUSTERED INDEX [IX_TSavingsPlanFFExt_PolicyBusinessId] ON [dbo].[TSavingsPlanFFExt] ([PolicyBusinessId]) INCLUDE ([InterestRate])
GO
