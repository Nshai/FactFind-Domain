CREATE TABLE [dbo].[TRefHistoryTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[TypeName] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[ArchiveFg] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NULL,
[RefHistoryTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefHistor_StampDateTime_1__58] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefHistoryTypeAudit] ADD CONSTRAINT [PK_TRefHistoryTypeAudit_2__58] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefHistoryTypeAudit_RefHistoryTypeId_ConcurrencyId] ON [dbo].[TRefHistoryTypeAudit] ([RefHistoryTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
