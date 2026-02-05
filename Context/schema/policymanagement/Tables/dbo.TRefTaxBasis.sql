CREATE TABLE [dbo].[TRefTaxBasis]
(
[RefTaxBasisId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefTaxBasisName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[RetireFg] [bit] NOT NULL CONSTRAINT [DF_TRefTaxBasis_RetireFg] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefTaxBasis_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefTaxBasis] ADD CONSTRAINT [PK_TRefTaxBasis] PRIMARY KEY NONCLUSTERED  ([RefTaxBasisId]) WITH (FILLFACTOR=80)
GO
