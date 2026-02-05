CREATE TABLE [dbo].[TGroupSchemeMemberImport]
(
[GroupSchemeMemberImportId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NOT NULL,
[GroupSchemeId] [int] NOT NULL,
[ImportFileId] [int] NOT NULL,
[DefaultCategoryId] [int] NULL,
[DefaultAdviserCRMContactId] [int] NULL,
[IsUpdateContributions] [bit] NOT NULL CONSTRAINT [DF_TGroupSchemeMemberImport_IsUpdateContributions] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TGroupSchemeMemberImport_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TGroupSchemeMemberImport] ADD CONSTRAINT [PK_TGroupSchemeMemberImport] PRIMARY KEY NONCLUSTERED  ([GroupSchemeMemberImportId])
GO
