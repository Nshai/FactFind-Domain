CREATE TABLE [dbo].[TOnlineApplicationStatusAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Status] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Description] [varchar] (200) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL,
[OnlineApplicationStatusId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TOnlineApplicationStatusAudit] ADD CONSTRAINT [PK_TOnlineApplicationStatusAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TOnlineApplicationStatusAudit_OnlineApplicationStatusId_ConcurrencyId] ON [dbo].[TOnlineApplicationStatusAudit] ([OnlineApplicationStatusId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
