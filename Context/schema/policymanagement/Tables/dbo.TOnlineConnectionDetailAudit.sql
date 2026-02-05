CREATE TABLE [dbo].[TOnlineConnectionDetailAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ConnectionName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Url] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Async] [bit] NULL,
[Timeout] [int] NULL,
[Username] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[Password] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[MessagePrefix] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[MessageSuffix] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[UrlEncode] [bit] NULL,
[ConcurrencyId] [int] NOT NULL,
[OnlineConnectionDetailId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TOnlineConnectionDetailAudit] ADD CONSTRAINT [PK_TOnlineConnectionDetailAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TOnlineConnectionDetailAudit_OnlineConnectionDetailId_ConcurrencyId] ON [dbo].[TOnlineConnectionDetailAudit] ([OnlineConnectionDetailId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
