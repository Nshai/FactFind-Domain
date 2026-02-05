CREATE TABLE [dbo].[TRefPaymentBasis]
(
[RefPaymentBasisId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefPaymentBasisName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[RetireFg] [bit] NOT NULL CONSTRAINT [DF_TRefPaymentBasis_RetireFg] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPaymentBasis_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefPaymentBasis] ADD CONSTRAINT [PK_TRefPaymentBasis] PRIMARY KEY NONCLUSTERED  ([RefPaymentBasisId]) WITH (FILLFACTOR=80)
GO
