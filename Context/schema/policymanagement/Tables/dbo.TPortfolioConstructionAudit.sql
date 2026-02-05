CREATE TABLE [dbo].[TPortfolioConstructionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_TPortfolioConstructionAudit_CreatedDate] DEFAULT (getdate()),
[Status] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[DocVersionId] [int] NULL,
[XmlContent] [text] COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPortfolioConstructionAudit_ConcurrencyId] DEFAULT ((1)),
[PortfolioConstructionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPortfolioConstructionAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPortfolioConstructionAudit] ADD CONSTRAINT [PK_TPortfolioConstructionAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
