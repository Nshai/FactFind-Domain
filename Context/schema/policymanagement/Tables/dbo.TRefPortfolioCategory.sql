CREATE TABLE [dbo].[TRefPortfolioCategory]
(
[RefPortfolioCategoryId] [int] NOT NULL IDENTITY(1, 1),
[PortfolioCategoryName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[PortfolioCategoryDisplayText] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL
)
GO
ALTER TABLE [dbo].[TRefPortfolioCategory] ADD CONSTRAINT [PK_TRefPortfolioCategory] PRIMARY KEY CLUSTERED ([RefPortfolioCategoryId])
GO
