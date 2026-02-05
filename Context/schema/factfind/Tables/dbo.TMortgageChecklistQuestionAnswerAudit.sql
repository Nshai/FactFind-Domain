CREATE TABLE [dbo].[TMortgageChecklistQuestionAnswerAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[MortgageChecklistQuestionAnswerId] [int] NOT NULL,
[MortgageChecklistQuestionId] [int] NOT NULL,
[Answer] [bit] NULL,
[CRMContactId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMortgageChecklistQuestionAnswerAudit_ConcurrencyId] DEFAULT ((1)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TMortgageChecklistQuestionAnswerAudit] ADD CONSTRAINT [PK_TMortgageChecklistQuestionAnswerAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
