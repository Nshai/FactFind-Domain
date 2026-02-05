CREATE TABLE [dbo].[TFinancialNotesAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FinancialNotes] [varchar] (4000) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[FinancialNotesId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TFinancialNotesAudit__ConcurrencyId] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFinancialNotesAudit] ADD CONSTRAINT [PK_TFinancialNotesAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
