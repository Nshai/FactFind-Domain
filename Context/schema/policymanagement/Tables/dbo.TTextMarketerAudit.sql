CREATE TABLE [dbo].[TTextMarketerAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[UserName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Password] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL,
[MessageFrom] [varchar] (16) COLLATE Latin1_General_CI_AS NOT NULL,
[ApplicationLinkId] [int] NOT NULL,
[TextMarketerId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDate] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TTextMarketerAudit] ADD CONSTRAINT [PK_TTextMarketerAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
