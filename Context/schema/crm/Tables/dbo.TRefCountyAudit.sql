CREATE TABLE [dbo].[TRefCountyAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CountyName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[RefCountryId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ArchiveFG] [tinyint] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[RefCountyId] [int] NOT NULL,
[CountyCode] [varchar] (10) COLLATE Latin1_General_CI_AS NULL,
[ParentCountyCode] [varchar] (10) COLLATE Latin1_General_CI_AS NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefCountyAudit] ADD CONSTRAINT [PK_TRefCountyAudit_1__54] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefCountyAudit_RefCountyId_ConcurrencyId] ON [dbo].[TRefCountyAudit] ([RefCountyId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TRefCountyAudit_StampDateTime_RefCountyId] ON [dbo].[TRefCountyAudit] ([StampDateTime], [RefCountyId]) WITH (FILLFACTOR=80)
GO
