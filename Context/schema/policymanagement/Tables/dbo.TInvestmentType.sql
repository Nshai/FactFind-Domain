CREATE TABLE [dbo].[TInvestmentType]
(
[InvestmentTypeId] [int] NOT NULL IDENTITY(1, 1),
[Descriptor] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NOT NULL,
[InvestmentCategoryId] [int] NOT NULL,
[DefaultRiskRating] [int] NULL,
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TInvestmentType_Guid] DEFAULT (newid()),
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TInvestmentType] ADD CONSTRAINT [PK_TInvestmentType] PRIMARY KEY CLUSTERED  ([InvestmentTypeId]) WITH (FILLFACTOR=80)
GO
