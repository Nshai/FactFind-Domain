CREATE TABLE [dbo].[TPostExistingProtectionPlansQuestions]
(
[PostExistingProtectionPlansQuestionsId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[NonDisclosure] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TPostExis__Concu__1FA39FB9] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TPostExistingProtectionPlansQuestions_CRMContactId] ON [dbo].[TPostExistingProtectionPlansQuestions] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
