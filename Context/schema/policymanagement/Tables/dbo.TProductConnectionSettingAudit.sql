CREATE TABLE [dbo].[TProductConnectionSettingAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ProgId] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[AsyncFG] [bit] NULL,
[AsyncAddress] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[SyncAddress] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ResponseAddress] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[SendQueue] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ResponseQueueSync] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ResponseQueueAsync] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[MessagePrefix] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[MessageSuffix] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[UrlEncodeFG] [bit] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[UserName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Password] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ProductConnectionSettingId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TProductCo_StampDateTime_1__52] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TProductConnectionSettingAudit] ADD CONSTRAINT [PK_TProductConnectionSettingAudit_2__52] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TProductConnectionSettingAudit_ProductConnectionSettingId_ConcurrencyId] ON [dbo].[TProductConnectionSettingAudit] ([ProductConnectionSettingId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
