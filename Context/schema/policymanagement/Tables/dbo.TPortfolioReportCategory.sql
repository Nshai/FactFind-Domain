CREATE TABLE [dbo].[TPortfolioReportCategory]
(
[PortfolioReportCategoryId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefPlanType2ProdSubTypeId] [int] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[Category] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[SubCategory] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPortfolioReportCategory_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPortfolioReportCategory] ADD CONSTRAINT [PK_TPortfolioReportCategory] PRIMARY KEY NONCLUSTERED  ([PortfolioReportCategoryId])
GO
ALTER TABLE [dbo].[TPortfolioReportCategory] ADD CONSTRAINT [FK_TPortfolioReportCategory_RefPlanType2ProdSubTypeId_RefPlanType2ProdSubTypeId] FOREIGN KEY ([RefPlanType2ProdSubTypeId]) REFERENCES [dbo].[TRefPlanType2ProdSubType] ([RefPlanType2ProdSubTypeId])
GO
ALTER TABLE [dbo].[TPortfolioReportCategory] ADD CONSTRAINT [FK_TPortfoloReportCategory_TRefPlanType2ProdSubType_RefPlanType2ProdSubTypeId] FOREIGN KEY ([RefPlanType2ProdSubTypeId]) REFERENCES [dbo].[TRefPlanType2ProdSubType] ([RefPlanType2ProdSubTypeId])
GO
