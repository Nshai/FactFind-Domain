CREATE TABLE [dbo].[TRefMortgageRepaymentMethod]
(
[RefMortgageRepaymentMethodId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[MortgageRepaymentMethod] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefRepaymentMethod_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefMortgageRepaymentMethod] ADD CONSTRAINT [PK_TRefRepaymentMethod] PRIMARY KEY CLUSTERED  ([RefMortgageRepaymentMethodId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TRefMortgageRepaymentMethod_IndigoClientId] ON [dbo].[TRefMortgageRepaymentMethod] ([IndigoClientId]) WITH (FILLFACTOR=80)
GO
