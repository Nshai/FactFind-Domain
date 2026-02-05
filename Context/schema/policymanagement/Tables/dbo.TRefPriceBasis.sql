CREATE TABLE [dbo].[TRefPriceBasis]
(
[RefPriceBasisId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[PriceBasis] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RetireFg] [bit] NULL CONSTRAINT [DF_TRefPriceBasis_RetireFg] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPriceBasis_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefPriceBasis] ADD CONSTRAINT [PK_TRefPriceBasis] PRIMARY KEY NONCLUSTERED  ([RefPriceBasisId]) WITH (FILLFACTOR=80)
GO
