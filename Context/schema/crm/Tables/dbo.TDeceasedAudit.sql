CREATE TABLE [dbo].[TDeceasedAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CRMContactId] [int] NOT NULL,
[DeceasedFG] [bit] NOT NULL,
[DeceasedDate] [datetime] NULL,
[ConcurrencyId] [int] NOT NULL,
[DeceasedId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TDeceasedAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[MigrationRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TDeceasedAudit] ADD CONSTRAINT [PK_TDeceasedAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TDeceasedAudit_CRMContactId] ON [dbo].[TDeceasedAudit] ([CRMContactId])
GO
CREATE NONCLUSTERED INDEX [IDX_TDeceasedAudit_DeceasedId_ConcurrencyId] ON [dbo].[TDeceasedAudit] ([DeceasedId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
