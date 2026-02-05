CREATE TABLE [dbo].[TAccountToRelationshipTypeLinkAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AccountToRelationshipTypeLinkId] [int] NOT NULL,
[RefRelationshipTypeId] [int] NOT NULL,
[AccountTypeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAccToRelAudit_ConcurrencyId] DEFAULT ((1)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAccToRelAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAccountToRelationshipTypeLinkAudit] ADD CONSTRAINT [PK_TAccountToRelationshipTypeLinkAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAccountToRelationshipTypeLinkAudit_AccountToRelationshipTypeLinkId_ConcurrencyId] ON [dbo].[TAccountToRelationshipTypeLinkAudit] ([AccountToRelationshipTypeLinkId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
