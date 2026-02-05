CREATE TABLE [dbo].[TPortfolioConstructionPreferenceAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NULL,
[PreferenceName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Value] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[PortfolioConstructionPreferenceId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPortfolioConstructionPreferenceAudit] ADD CONSTRAINT [PK_TPortfolioConstructionPreferenceAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
