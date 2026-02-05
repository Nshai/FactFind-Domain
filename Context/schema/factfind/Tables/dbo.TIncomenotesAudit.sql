CREATE TABLE [dbo].[TIncomenotesAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[incnotes] [varchar] (4000) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[IncomenotesId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TIncomeno__Concu__7948ECA7] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TIncomenotesAudit] ADD CONSTRAINT [PK_TIncomenotesAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
