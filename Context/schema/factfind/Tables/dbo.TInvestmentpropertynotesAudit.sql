CREATE TABLE [dbo].[TInvestmentpropertynotesAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[investmentpropertynotes] [varchar] (4000) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[InvestmentpropertynotesId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TInvestme__Concu__7D197D8B] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TInvestmentpropertynotesAudit] ADD CONSTRAINT [PK_TInvestmentpropertynotesAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
