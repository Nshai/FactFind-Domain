CREATE TABLE [dbo].[THealthAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Comment] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[CrmContactId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[HealthId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_THealthAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[THealthAudit] ADD CONSTRAINT [PK_THealthAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_THealthAudit_HealthId_ConcurrencyId] ON [dbo].[THealthAudit] ([HealthId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
