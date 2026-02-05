CREATE TABLE [dbo].[TPostExistingFinalSalaryPensionPlansQuestions]
(
[PostExistingFinalSalaryPensionPlansQuestionsId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[NonDisclosure] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TPostExis__Concu__255C790F] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TPostExistingFinalSalaryPensionPlansQuestions_CRMContactId] ON [dbo].[TPostExistingFinalSalaryPensionPlansQuestions] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
