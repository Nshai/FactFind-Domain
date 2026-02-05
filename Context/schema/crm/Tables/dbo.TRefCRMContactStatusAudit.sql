CREATE TABLE [dbo].[TRefCRMContactStatusAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[StatusName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[OrderNo] [int] NULL,
[Extensible] [dbo].[extensible] NULL,
[InternalFG] [tinyint] NULL,
[ConcurrencyId] [int] NOT NULL,
[RefCRMContactStatusId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefCRMCon_StampDateTime_1__53] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefCRMContactStatusAudit] ADD CONSTRAINT [PK_TRefCRMContactStatusAudit_2__53] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefCRMContactStatusAudit_RefCRMContactStatusId_ConcurrencyId] ON [dbo].[TRefCRMContactStatusAudit] ([RefCRMContactStatusId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
