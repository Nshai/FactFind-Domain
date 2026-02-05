CREATE TABLE [dbo].[TRepossessedExtAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[PropertyRepossessedFg] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRepossessedExtAudit_ConcurrencyId] DEFAULT ((1)),
[RepossessedExtId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRepossessedExtAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRepossessedExtAudit] ADD CONSTRAINT [PK_TRepossessedExtAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TRepossessedExtAudit_RepossessedExtId_ConcurrencyId] ON [dbo].[TRepossessedExtAudit] ([RepossessedExtId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
