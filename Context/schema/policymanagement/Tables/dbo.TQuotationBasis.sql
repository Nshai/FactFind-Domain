CREATE TABLE [dbo].[TQuotationBasis]
(
[QuotationBasisId] [int] NOT NULL IDENTITY(1, 1),
[QuotationBasisType] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[MinValue] [decimal] (19, 2) NOT NULL,
[MaxValue] [decimal] (19, 2) NOT NULL,
[RateOfIncrease] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQuotationBasis_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TQuotationBasis] ADD CONSTRAINT [PK_TQuotationBasis] PRIMARY KEY CLUSTERED  ([QuotationBasisId])
GO
