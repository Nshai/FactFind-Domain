CREATE TABLE [dbo].[TPostExistingOtherInvestmentPlansQuestions]
(
[PostExistingOtherInvestmentPlansQuestionsId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[NonDisclosure] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TPostExis__Concu__30CE2BBB] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TPostExistingOtherInvestmentPlansQuestions_CRMContactId] ON [dbo].[TPostExistingOtherInvestmentPlansQuestions] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
