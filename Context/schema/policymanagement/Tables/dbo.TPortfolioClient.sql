CREATE TABLE [dbo].[TPortfolioClient]
(
[PortfolioClientId] [int] NOT NULL IDENTITY(1, 1),
[PortfolioId] [int] NOT NULL,
[CreatedBy] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[CRMContactId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPortfolioClient_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPortfolioClient] ADD CONSTRAINT [PK_TPortfolioClient] PRIMARY KEY NONCLUSTERED  ([PortfolioClientId])
GO
