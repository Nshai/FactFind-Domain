CREATE TABLE [dbo].[TRefRelationshipTypeLinkAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefRelTypeId] [int] NOT NULL,
[RefRelCorrespondTypeId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[RefRelationshipTypeLinkId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefRelati_StampDateTime_3__57] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefRelationshipTypeLinkAudit] ADD CONSTRAINT [PK_TRefRelationshipTypeLinkAudit_4__57] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefRelationshipTypeLinkAudit_RefRelationshipTypeLinkId_ConcurrencyId] ON [dbo].[TRefRelationshipTypeLinkAudit] ([RefRelationshipTypeLinkId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
