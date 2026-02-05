CREATE TABLE [dbo].[TRefInvestmentType]
(
[RefInvestmentTypeId] [int] NOT NULL IDENTITY(1, 1),
[InvestmentType] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefInvestmentType_ConcurrencyId] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TRefInvestmentType] ADD CONSTRAINT [PK_TRefInvestmentType] PRIMARY KEY NONCLUSTERED  ([RefInvestmentTypeId])
GO
