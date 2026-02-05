CREATE TABLE [dbo].[TRefCorporateTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[TypeName] [varchar] (250) COLLATE Latin1_General_CI_AS NULL,
[HasCompanyRegFg] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ArchiveFg] [tinyint] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefCorpor_ConcurrencyId_1__56] DEFAULT ((1)),
[RefCorporateTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefCorpor_StampDateTime_2__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefCorporateTypeAudit] ADD CONSTRAINT [PK_TRefCorporateTypeAudit_3__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefCorporateTypeAudit_RefCorporateTypeId_ConcurrencyId] ON [dbo].[TRefCorporateTypeAudit] ([RefCorporateTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
