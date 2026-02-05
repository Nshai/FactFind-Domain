CREATE TABLE [dbo].[TRefValuationBasis]
(
[RefValuationBasisId] [int] NOT NULL IDENTITY(1, 1),
[ValuationBasisName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[CalculationType] [tinyint] NULL,
[NumMonths] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefValuationBasis_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefValuationBasis] ADD CONSTRAINT [PK_TRefValuationBasis] PRIMARY KEY NONCLUSTERED  ([RefValuationBasisId]) WITH (FILLFACTOR=80)
GO
