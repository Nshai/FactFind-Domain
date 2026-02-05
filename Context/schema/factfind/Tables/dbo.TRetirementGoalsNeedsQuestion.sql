CREATE TABLE [dbo].[TRetirementGoalsNeedsQuestion]
(
[RetirementGoalsNeedsQuestionId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[RequiredIncome] [money] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TRetireme__Concu__3C3FDE67] DEFAULT ((1)),
[IsThereASpecificInvestmentPreference] [bit] NULL,
[IsFutureMoneyAnticipated] [bit] NULL
)
GO
CREATE NONCLUSTERED INDEX [IDX_TRetirementGoalsNeedsQuestion_CRMContactId] ON [dbo].[TRetirementGoalsNeedsQuestion] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
