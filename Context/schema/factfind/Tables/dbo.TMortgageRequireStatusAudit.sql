CREATE TABLE [dbo].[TMortgageRequireStatusAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[ExPat] [bit] NULL,
[ForeignCitizen] [bit] NULL,
[Status] [bit] NULL,
[SelfCert] [bit] NULL,
[NonStatus] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMortgageRequireStatusAudit_ConcurrencyId] DEFAULT ((1)),
[MortgageRequireStatusId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TMortgageRequireStatusAudit] ADD CONSTRAINT [PK_TMortgageRequireStatusAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
