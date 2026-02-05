CREATE TABLE [dbo].[TBusinessInvestmentNeedNoteAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Notes] [varchar] (4000) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[BusinessInvestmentNeedNoteId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TBusiness__Concu__477C86E9] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TBusinessInvestmentNeedNoteAudit] ADD CONSTRAINT [PK_TBusinessInvestmentNeedNoteAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
