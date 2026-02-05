CREATE TABLE [dbo].[TRetirementGoalsNeedsQuestionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RequiredIncome] [money] NULL,
[CRMContactId] [int] NOT NULL,
[RetirementGoalsNeedsQuestionId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TRetireme__Concu__0FF747D5] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsThereASpecificInvestmentPreference] [bit] NULL,
[IsFutureMoneyAnticipated] [bit] NULL
)
GO
ALTER TABLE [dbo].[TRetirementGoalsNeedsQuestionAudit] ADD CONSTRAINT [PK_TRetirementGoalsNeedsQuestionAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
