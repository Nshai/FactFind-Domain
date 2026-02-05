CREATE TABLE [dbo].[TPolicyFundValuation]
(
[PolicyFundValuationId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[PolicyFundId] [int] NULL,
[FundValue] [money] NULL,
[FundValuationDate] [datetime] NULL,
[UpdatedByUserId] [int] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyFundValuation_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPolicyFundValuation] ADD CONSTRAINT [PK_TPolicyFundValuation] PRIMARY KEY NONCLUSTERED  ([PolicyFundValuationId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyFundValuation_PolicyFundId] ON [dbo].[TPolicyFundValuation] ([PolicyFundId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TPolicyFundValuation] ADD CONSTRAINT [FK_TPolicyFundValuation_PolicyFundId_PolicyFundId] FOREIGN KEY ([PolicyFundId]) REFERENCES [dbo].[TPolicyFund] ([PolicyFundId])
GO
