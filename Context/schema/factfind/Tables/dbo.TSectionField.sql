CREATE TABLE [dbo].[TSectionField]
(
[SectionFieldId] [int] NOT NULL IDENTITY(1, 1),
[SectionId] [int] NULL,
[FieldId] [int] NULL,
[Ordinal] [tinyint] NULL,
[VisibleFg] [bit] NULL,
[EventXml] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[FieldLabel] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TSectionField_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TSectionField] ADD CONSTRAINT [PK_TSectionField] PRIMARY KEY NONCLUSTERED  ([SectionFieldId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TSectionField_FieldId] ON [dbo].[TSectionField] ([FieldId], [SectionId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_dbo_TSectionField_SectionId] ON [dbo].[TSectionField] ([SectionId]) WITH (FILLFACTOR=80)
GO
CREATE CLUSTERED INDEX [IX_TSectionField_Test] ON [dbo].[TSectionField] ([SectionId], [FieldId], [Ordinal]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TSectionField] WITH NOCHECK ADD CONSTRAINT [FK_TSectionField_FieldId_FieldId] FOREIGN KEY ([FieldId]) REFERENCES [dbo].[TField] ([FieldId])
GO
ALTER TABLE [dbo].[TSectionField] WITH NOCHECK ADD CONSTRAINT [FK_TSectionField_SectionId_SectionId] FOREIGN KEY ([SectionId]) REFERENCES [dbo].[TSection] ([SectionId])
GO
