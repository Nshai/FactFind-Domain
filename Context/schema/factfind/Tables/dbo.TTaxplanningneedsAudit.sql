CREATE TABLE [dbo].[TTaxplanningneedsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[giftsofCapitalYN] [bit] NULL,
[giftsofCapitalCurrentPreviousYN] [bit] NULL,
[giftsOutOfIncomeYN] [bit] NULL,
[potentialIHTValue] [money] NULL,
[CRMContactId] [int] NOT NULL,
[TaxplanningneedsId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TTaxplann__Concu__0A7378A9] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TTaxplanningneedsAudit] ADD CONSTRAINT [PK_TTaxplanningneedsAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
