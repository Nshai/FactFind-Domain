CREATE TABLE [dbo].[TFieldVisibility]
(
[FieldVisibilityId] [int] NOT NULL IDENTITY(1, 1),
[Field] [varchar] (32) COLLATE Latin1_General_CI_AS NOT NULL,
[SectionDefinitionId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_FieldVisibility_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFieldVisibility] ADD CONSTRAINT [PK_TFieldVisibility_FieldVisibilityId] PRIMARY KEY CLUSTERED  ([FieldVisibilityId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TFieldVisibilityAudit_FieldVisibilityId_ConcurrencyId] ON [dbo].[TFieldVisibility] ([FieldVisibilityId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TFieldVisibility] ADD CONSTRAINT [FK_TFieldVisibility_SectionDefinitionId_SectionDefinitionId] FOREIGN KEY ([SectionDefinitionId]) REFERENCES [dbo].[TSectionDefinition] ([SectionDefinitionId])
GO
