CREATE TABLE [dbo].[TInvestmentneednotesAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[investmentneednotes] [varchar] (4000) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[InvestmentneednotesId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TInvestme__Concu__7B313519] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TInvestmentneednotesAudit] ADD CONSTRAINT [PK_TInvestmentneednotesAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
