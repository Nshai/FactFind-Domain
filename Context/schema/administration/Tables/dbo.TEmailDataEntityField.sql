CREATE TABLE [dbo].[TEmailDataEntityField]
(
[EmailDataEntityFieldId] [int] NOT NULL IDENTITY(1, 1),
[Descriptor] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[EmailDataEntityId] [int] NOT NULL,
[Identifier] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[XPath] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEmailDataEntityField_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TEmailDataEntityField] ADD CONSTRAINT [PK_TEmailDataEntityField] PRIMARY KEY CLUSTERED  ([EmailDataEntityFieldId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TEmailDataEntityField_EmailDataEntityIdASC] ON [dbo].[TEmailDataEntityField] ([EmailDataEntityId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TEmailDataEntityField] ADD CONSTRAINT [FK_TEmailDataEntityField_EmailDataEntityId_EmailDataEntityId] FOREIGN KEY ([EmailDataEntityId]) REFERENCES [dbo].[TEmailDataEntity] ([EmailDataEntityId])
GO
