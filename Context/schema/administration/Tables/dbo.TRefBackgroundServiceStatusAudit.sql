CREATE TABLE [dbo].[TRefBackgroundServiceStatusAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[StatusName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefBackgroundServiceStatusAudit_ConcurrencyId] DEFAULT ((1)),
[RefBackgroundServiceStatusId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefBackgroundServiceStatusAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefBackgroundServiceStatusAudit] ADD CONSTRAINT [PK_TRefBackgroundServiceStatusAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TRefBackgroundServiceStatusAudit_RefBackgroundServiceStatusId_ConcurrencyId] ON [dbo].[TRefBackgroundServiceStatusAudit] ([RefBackgroundServiceStatusId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
