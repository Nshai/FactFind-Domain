CREATE TABLE [dbo].[TRetainerStatusAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RetainerId] [int] NOT NULL,
[Status] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[StatusNotes] [varchar] (250) COLLATE Latin1_General_CI_AS NULL,
[StatusDate] [datetime] NOT NULL,
[UpdatedUserId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRetainerS_ConcurrencyId_2__56] DEFAULT ((1)),
[RetainerStatusId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRetainerS_StampDateTime_4__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRetainerStatusAudit] ADD CONSTRAINT [PK_TRetainerStatusAudit_5__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRetainerStatusAudit_RetainerStatusId_ConcurrencyId] ON [dbo].[TRetainerStatusAudit] ([RetainerStatusId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
