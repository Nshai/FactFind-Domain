CREATE TABLE [dbo].[TOnlineApplicationAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NULL,
[OnlineProductId] [int] NULL,
[OnlineApplicationStatusId] [int] NULL,
[SavedXml] [text] COLLATE Latin1_General_CI_AS NULL,
[SavedDate] [datetime] NULL,
[RequestXml] [text] COLLATE Latin1_General_CI_AS NULL,
[RequestDate] [datetime] NULL,
[ResponseXml] [text] COLLATE Latin1_General_CI_AS NULL,
[ResponseDate] [datetime] NULL,
[ConcurrencyId] [int] NOT NULL,
[OnlineApplicationId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TOnlineApplicationAudit] ADD CONSTRAINT [PK_TOnlineApplicationAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TOnlineApplicationAudit_OnlineApplicationId_ConcurrencyId] ON [dbo].[TOnlineApplicationAudit] ([OnlineApplicationId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
