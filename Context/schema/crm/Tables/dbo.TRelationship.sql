CREATE TABLE [dbo].[TRelationship]
(
[RelationshipId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefRelTypeId] [int] NULL,
[RefRelCorrespondTypeId] [int] NULL,
[CRMContactFromId] [int] NOT NULL,
[CRMContactToId] [int] NULL,
[ExternalContact] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ExternalURL] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[OtherRelationship] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsPartnerFg] [bit] NULL,
[IsFamilyFg] [bit] NULL,
[IsPointOfContactFg] [bit] NULL,
[IncludeInPfp] [bit] NULL,
[ReceivedAccessType] [varchar](50) NULL,
[ReceivedAccessAt] [datetime] NULL,
[ReceivedAccessByUserId] [int] NULL,
[GivenAccessType] [varchar](50) NULL,
[GivenAccessAt] [datetime] NULL,
[GivenAccessByUserId] [int] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRelations_ConcurrencyId_1__57] DEFAULT ((1)),
[StartedAt] [datetime] NULL,
MigrationRef varchar(255)
)
GO
ALTER TABLE [dbo].[TRelationship] ADD CONSTRAINT [PK_TRelationship_2__57] PRIMARY KEY NONCLUSTERED  ([RelationshipId]) WITH (FILLFACTOR=75)
GO
CREATE NONCLUSTERED INDEX [IX_TRelationship_CRMContactFromId_CRMContactToId] ON [dbo].[TRelationship] ([CRMContactFromId], [CRMContactToId]) Include ([IncludeInPFP])
GO
CREATE NONCLUSTERED INDEX [IX_TRelationship] ON [dbo].[TRelationship] ([CRMContactToId], [CRMContactFromId])
GO
CREATE NONCLUSTERED INDEX [IDX_TRelationship_RefRelCorrespondTypeId] ON [dbo].[TRelationship] ([RefRelCorrespondTypeId]) WITH (FILLFACTOR=75)
GO
CREATE NONCLUSTERED INDEX [IDX_TRelationship_RefRelTypeId] ON [dbo].[TRelationship] ([RefRelTypeId]) WITH (FILLFACTOR=75)
GO
ALTER TABLE [dbo].[TRelationship] ADD CONSTRAINT [FK_TRelationship_RefRelCorrespondTypeId_RefRelationshipTypeId] FOREIGN KEY ([RefRelCorrespondTypeId]) REFERENCES [dbo].[TRefRelationshipType] ([RefRelationshipTypeId])
GO
ALTER TABLE [dbo].[TRelationship] ADD CONSTRAINT [FK_TRelationship_RefRelTypeId_RefRelationshipTypeId] FOREIGN KEY ([RefRelTypeId]) REFERENCES [dbo].[TRefRelationshipType] ([RefRelationshipTypeId])
GO
create index IX_TRelationship_MigrationRef_CRMContactFromId_CRMContactToId_RefRelTypeId_RefRelCorrespondTypeId on TRelationship(MigrationRef,CRMContactFromId,CRMContactToId,RefRelTypeId,RefRelCorrespondTypeId) 
go 