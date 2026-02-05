CREATE TABLE [dbo].[TRefEscalationTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[EscalationType] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RetireFg] [bit] NULL,
[ConcurrencyId] [int] NOT NULL,
[RefEscalationTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefEscalationTypeAudit] ADD CONSTRAINT [PK_TRefEscalationTypeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefEscalationTypeAudit_RefEscalationTypeId_ConcurrencyId] ON [dbo].[TRefEscalationTypeAudit] ([RefEscalationTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
