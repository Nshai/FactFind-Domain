CREATE TABLE [dbo].[TRefRelationshipTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RelationshipTypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ArchiveFg] [tinyint] NULL,
[PersonFg] [tinyint] NULL,
[CorporateFg] [tinyint] NULL,
[TrustFg] [tinyint] NULL,
[AccountFg] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[RefRelationshipTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefRelati_StampDateTime_1__51] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefRelationshipTypeAudit] ADD CONSTRAINT [PK_TRefRelationshipTypeAudit_2__51] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
