CREATE TABLE [dbo].[TPolicyUnitValuation]
(
[PolicyUnitValuationId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[PolicyFundId] [int] NULL,
[UnitValue] [int] NULL,
[UnitValuationDate] [datetime] NULL,
[UpdatedByUserId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyUnitValuation_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPolicyUnitValuation] ADD CONSTRAINT [PK_TPolicyUnitValuation] PRIMARY KEY NONCLUSTERED  ([PolicyUnitValuationId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyUnitValuation_PolicyFundId] ON [dbo].[TPolicyUnitValuation] ([PolicyFundId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TPolicyUnitValuation] ADD CONSTRAINT [FK_TPolicyUnitValuation_PolicyFundId_PolicyFundId] FOREIGN KEY ([PolicyFundId]) REFERENCES [dbo].[TPolicyFund] ([PolicyFundId])
GO
