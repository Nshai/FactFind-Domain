CREATE TABLE [dbo].[TPortfolioReportCategoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PortfolioReportCategory] [int] NOT NULL,
[RefPlanType2ProdSubTypeId] [int] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[Category] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[SubCategory] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPortfolioReportCategoryAudit_ConcurrencyId] DEFAULT ((1)),
[PortfolioReportCategoryId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPortfolioReportCategoryAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPortfolioReportCategoryAudit] ADD CONSTRAINT [PK_TPortfolioReportCategoryAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPortfolioReportCategoryAudit_PortfolioReportCategoryId_ConcurrencyId] ON [dbo].[TPortfolioReportCategoryAudit] ([PortfolioReportCategoryId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
