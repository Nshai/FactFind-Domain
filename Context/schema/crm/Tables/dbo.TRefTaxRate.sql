CREATE TABLE [dbo].[TRefTaxRate]
(
[RefTaxRateId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[TaxRate] [decimal] (10, 1) NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TRefTaxRate_IsArchived] DEFAULT ((0)),
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefTaxRate_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefTaxRate] ADD CONSTRAINT [PK_TRefTaxRate_RefTaxRateId] PRIMARY KEY NONCLUSTERED  ([RefTaxRateId]) WITH (FILLFACTOR=75)
GO
