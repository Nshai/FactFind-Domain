CREATE TABLE [dbo].[TFactFindDocumentAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[FactFindDocumentTypeId] [int] NOT NULL,
[DocVersionId] [int] NOT NULL,
[CrmContactId] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_TFactFindDocumentAudit_CreatedDate] DEFAULT (getdate()),
[Creator] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IsFull] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFactFindDocumentAudit_ConcurrencyId] DEFAULT ((1)),
[FactFindDocumentId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFactFindDocumentAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[MigrationRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFactFindDocumentAudit] ADD CONSTRAINT [PK_TFactFindDocumentAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TFactFindDocumentAudit_FactFindDocumentId_ConcurrencyId] ON [dbo].[TFactFindDocumentAudit] ([FactFindDocumentId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
