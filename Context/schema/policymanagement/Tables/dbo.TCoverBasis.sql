CREATE TABLE [dbo].[TCoverBasis]
(
[CoverBasisId] [int] NOT NULL IDENTITY(1, 1),
[QuoteId] [int] NOT NULL,
[BasisType] [int] NULL,
[CriticalIllnessDetailId] [int] NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCoverBasis_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TCoverBasis] ADD CONSTRAINT [PK_TCoverBasis] PRIMARY KEY CLUSTERED  ([CoverBasisId])
GO
ALTER TABLE [dbo].[TCoverBasis] WITH CHECK ADD CONSTRAINT [FK_TCoverBasis_TQuote] FOREIGN KEY ([QuoteId]) REFERENCES [dbo].[TQuote] ([QuoteId])
GO
