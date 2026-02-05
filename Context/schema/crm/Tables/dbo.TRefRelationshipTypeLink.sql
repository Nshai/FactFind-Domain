CREATE TABLE [dbo].[TRefRelationshipTypeLink]
(
[RefRelationshipTypeLinkId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefRelTypeId] [int] NOT NULL,
[RefRelCorrespondTypeId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefRelati_ConcurrencyId_3__57] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefRelationshipTypeLink] ADD CONSTRAINT [PK_TRefRelationshipTypeLink_4__57] PRIMARY KEY NONCLUSTERED  ([RefRelationshipTypeLinkId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TRefRelationshipTypeLink_RefRelCorrespondTypeId] ON [dbo].[TRefRelationshipTypeLink] ([RefRelCorrespondTypeId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TRefRelationshipTypeLink_RefRelTypeId] ON [dbo].[TRefRelationshipTypeLink] ([RefRelTypeId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TRefRelationshipTypeLink] ADD CONSTRAINT [FK_TRefRelationshipTypeLink_RefRelCorrespondTypeId_RefRelationshipTypeId] FOREIGN KEY ([RefRelCorrespondTypeId]) REFERENCES [dbo].[TRefRelationshipType] ([RefRelationshipTypeId])
GO
ALTER TABLE [dbo].[TRefRelationshipTypeLink] ADD CONSTRAINT [FK_TRefRelationshipTypeLink_RefRelTypeId_RefRelationshipTypeId] FOREIGN KEY ([RefRelTypeId]) REFERENCES [dbo].[TRefRelationshipType] ([RefRelationshipTypeId])
GO
