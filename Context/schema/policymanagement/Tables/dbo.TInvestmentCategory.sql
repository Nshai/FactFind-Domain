CREATE TABLE [dbo].[TInvestmentCategory]
(
[InvestmentCategoryId] [int] NOT NULL IDENTITY(1, 1),
[Descriptor] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NOT NULL,
[OrderNbr] [int] NULL,
[ChartSeriesColour] [varchar] (10) COLLATE Latin1_General_CI_AS NULL,
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TInvestmentCategory_Guid] DEFAULT (newid()),
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TInvestmentCategory] ADD CONSTRAINT [PK_TInvestmentCategory] PRIMARY KEY CLUSTERED  ([InvestmentCategoryId]) WITH (FILLFACTOR=80)
GO
