CREATE TABLE [dbo].[TPolicyMoneyInExtended]
(
[PolicyMoneyInExtendedId] [int] NOT NULL IDENTITY(1, 1),
[PolicyMoneyInId] [int] NOT NULL,
[MigrationRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
