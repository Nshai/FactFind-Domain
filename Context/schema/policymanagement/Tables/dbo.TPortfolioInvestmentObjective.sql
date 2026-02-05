CREATE TABLE [dbo].[TPortfolioInvestmentObjective](
	[PortfolioInvestmentObjectiveId] [int] NOT NULL IDENTITY(1, 1),
	[PortfolioId] [int] NOT NULL,
	[InvestmentObjective] [varchar](255) NOT NULL
)