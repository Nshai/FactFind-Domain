CREATE TABLE [dbo].[TPostExistingCashDepositPlansQuestions]
(
[PostExistingCashDepositPlansQuestionsId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[NonDisclosure] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TPostExis__Concu__2CFD9AD7] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TPostExistingCashDepositPlansQuestions_CRMContactId] ON [dbo].[TPostExistingCashDepositPlansQuestions] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
