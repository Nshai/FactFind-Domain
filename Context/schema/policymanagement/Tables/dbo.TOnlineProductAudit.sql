CREATE TABLE [dbo].[TOnlineProductAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[PacId] [int] NULL,
[OnlineConnectionDetailId] [int] NULL,
[ConcurrencyId] [int] NULL,
[OnlineProductId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TOnlineProductAudit] ADD CONSTRAINT [PK_TOnlineProductAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TOnlineProductAudit_OnlineProductId_ConcurrencyId] ON [dbo].[TOnlineProductAudit] ([OnlineProductId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
