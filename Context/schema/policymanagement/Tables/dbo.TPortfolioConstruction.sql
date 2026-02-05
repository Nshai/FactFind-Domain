CREATE TABLE [dbo].[TPortfolioConstruction]
(
[PortfolioConstructionId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_TPortfolioConstruction_CreatedDate] DEFAULT (getdate()),
[Status] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[DocVersionId] [int] NULL,
[XmlContent] [text] COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPortfolioConstruction_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPortfolioConstruction] ADD CONSTRAINT [PK_TPortfolioConstruction] PRIMARY KEY CLUSTERED  ([PortfolioConstructionId]) WITH (FILLFACTOR=80)
GO
