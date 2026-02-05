CREATE TABLE [dbo].[TRefContactTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ContactTypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ArchiveFG] [tinyint] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[RefContactTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefContactTypeAudit] ADD CONSTRAINT [PK_TRefContactTypeAudit_1__54] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefContactTypeAudit_RefContactTypeId_ConcurrencyId] ON [dbo].[TRefContactTypeAudit] ([RefContactTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
