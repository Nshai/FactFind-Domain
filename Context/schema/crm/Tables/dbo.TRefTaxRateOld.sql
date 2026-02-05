CREATE TABLE [dbo].[TRefTaxRateOld]
(
[RefTaxRateId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefTaxRat_ConcurrencyId_1__57] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefTaxRateOld] ADD CONSTRAINT [PK_TRefTaxRate_2__57] PRIMARY KEY NONCLUSTERED  ([RefTaxRateId]) WITH (FILLFACTOR=80)
GO
