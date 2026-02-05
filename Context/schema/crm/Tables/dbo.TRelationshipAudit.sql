CREATE TABLE [dbo].[TRelationshipAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefRelTypeId] [int] NULL,
[RefRelCorrespondTypeId] [int] NULL,
[CRMContactFromId] [int] NULL,
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
[ConcurrencyId] [int] NOT NULL,
[RelationshipId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[StartedAt] [datetime] NULL,
MigrationRef varchar(255)
)
GO
ALTER TABLE [dbo].[TRelationshipAudit] ADD CONSTRAINT [PK_TRelationshipAudit_1__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=75)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRelationshipAudit_RelationshipId_ConcurrencyId] ON [dbo].[TRelationshipAudit] ([RelationshipId], [ConcurrencyId]) WITH (FILLFACTOR=75)
GO
