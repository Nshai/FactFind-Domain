CREATE TABLE [dbo].[TRefRelationshipType]
(
[RefRelationshipTypeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RelationshipTypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ArchiveFg] [tinyint] NULL,
[PersonFg] [tinyint] NULL,
[CorporateFg] [tinyint] NULL,
[TrustFg] [tinyint] NULL,
[AccountFg] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefRelati_ConcurrencyId_1__57] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefRelationshipType] ADD CONSTRAINT [PK_TRefRelationshipType_2__57] PRIMARY KEY NONCLUSTERED  ([RefRelationshipTypeId]) WITH (FILLFACTOR=80)
GO
