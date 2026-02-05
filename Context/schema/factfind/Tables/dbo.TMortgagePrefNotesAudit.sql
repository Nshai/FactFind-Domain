CREATE TABLE [dbo].[TMortgagePrefNotesAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[notes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMortgagePrefNotesAudit_ConcurrencyId] DEFAULT ((1)),
[MortgagePrefNotesId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TMortgagePrefNotesAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TMortgagePrefNotesAudit] ADD CONSTRAINT [PK_TMortgagePrefNotesAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TMortgagePrefNotesAudit_MortgagePrefNotesId_ConcurrencyId] ON [dbo].[TMortgagePrefNotesAudit] ([MortgagePrefNotesId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
