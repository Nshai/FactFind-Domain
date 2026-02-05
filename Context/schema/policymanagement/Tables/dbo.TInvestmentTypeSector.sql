CREATE TABLE [dbo].[TInvestmentTypeSector]
(
[InvestmentTypeSectorId] [int] NOT NULL IDENTITY(1, 1),
[CategoryId] [int] NOT NULL,
[FundTypeId] [int] NOT NULL,
[InvestmentTypeId] [int] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TInvestmentTypeSector_Guid] DEFAULT (newid()),
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TInvestmentTypeSector] ADD CONSTRAINT [PK_TInvestmentTypeSector] PRIMARY KEY NONCLUSTERED  ([InvestmentTypeSectorId]) WITH (FILLFACTOR=80)
GO
