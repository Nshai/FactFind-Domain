CREATE TABLE [dbo].[TClientActivityLogAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Activity] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Application] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[TimeStamp] [datetime] NOT NULL CONSTRAINT [DF_TClientActivityLogAudit_TimeStamp] DEFAULT (getdate()),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TClientActivityLogAudit_ConcurrencyId] DEFAULT ((1)),
[ClientActivityLogId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TClientActivityLogAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TClientActivityLogAudit] ADD CONSTRAINT [PK_TClientActivityLogAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TClientActivityLogAudit_ClientActivityLogId_ConcurrencyId] ON [dbo].[TClientActivityLogAudit] ([ClientActivityLogId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
