CREATE TABLE [dbo].[TGroupSchemeMemberImportAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NOT NULL,
[GroupSchemeId] [int] NOT NULL,
[ImportFileId] [int] NOT NULL,
[DefaultCategoryId] [int] NULL,
[DefaultAdviserCRMContactId] [int] NULL,
[IsUpdateContributions] [bit] NOT NULL CONSTRAINT [DF_TGroupSchemeMemberImportAudit_IsUpdateContributions] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TGroupSchemeMemberImportAudit_ConcurrencyId] DEFAULT ((1)),
[GroupSchemeMemberImportId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TGroupSchemeMemberImportAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TGroupSchemeMemberImportAudit] ADD CONSTRAINT [PK_TGroupSchemeMemberImportAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TGroupSchemeMemberImportAudit_GroupSchemeMemberImportId_ConcurrencyId] ON [dbo].[TGroupSchemeMemberImportAudit] ([GroupSchemeMemberImportId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
