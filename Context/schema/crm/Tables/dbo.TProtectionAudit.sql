CREATE TABLE [dbo].[TProtectionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (64) COLLATE Latin1_General_CI_AS NOT NULL,
[Income] [money] NULL,
[LumpSum] [money] NULL,
[Term] [int] NULL,
[BorneBy] [varchar] (16) COLLATE Latin1_General_CI_AS NULL,
[Joint] [bit] NOT NULL,
[CrmContactId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[ProtectionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TProtectionAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TProtectionAudit] ADD CONSTRAINT [PK_TProtectionAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TProtectionAudit_ProtectionId_ConcurrencyId] ON [dbo].[TProtectionAudit] ([ProtectionId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
