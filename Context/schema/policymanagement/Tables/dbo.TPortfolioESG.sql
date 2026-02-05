CREATE TABLE [dbo].[TPortfolioESG](
	[PortfolioESGId] [int] NOT NULL IDENTITY(1, 1),
	[PortfolioId] [int] NOT NULL,
	[ESGValue] [varchar](255) NOT NULL
)