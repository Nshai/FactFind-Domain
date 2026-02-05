CREATE TABLE [dbo].[TRefCountryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CountryName] [varchar] (255) NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ArchiveFG] [tinyint] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[RefCountryId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) NULL,
[CountryCode] [varchar] (10) NULL
)
GO
ALTER TABLE [dbo].[TRefCountryAudit] ADD CONSTRAINT [PK_TRefCountryAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_Audit_TRefCountryAudit_RefCountryId_ConcurrencyId] ON [dbo].[TRefCountryAudit] ([RefCountryId], [ConcurrencyId])
GO
