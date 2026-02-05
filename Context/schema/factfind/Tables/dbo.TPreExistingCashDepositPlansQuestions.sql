CREATE TABLE [dbo].[TPreExistingCashDepositPlansQuestions]
(
[PreExistingCashDepositPlansQuestionsId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[ExistingCashDepositAccounts] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TPreExist__Concu__2B155265] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TPreExistingCashDepositPlansQuestions_CRMContactId] ON [dbo].[TPreExistingCashDepositPlansQuestions] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
