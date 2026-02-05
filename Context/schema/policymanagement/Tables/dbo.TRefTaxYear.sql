CREATE TABLE [dbo].[TRefTaxYear]
(
[RefTaxYearId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefTaxYearName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[RetireFg] [bit] NOT NULL CONSTRAINT [DF_TRefTaxYear_RetireFg] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefTaxYear_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefTaxYear] ADD CONSTRAINT [PK_TRefTaxYear] PRIMARY KEY NONCLUSTERED  ([RefTaxYearId]) WITH (FILLFACTOR=80)
GO
