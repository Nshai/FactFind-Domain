CREATE TABLE [dbo].[TPreExistingOtherInvestmentPlansQuestions]
(
[PreExistingOtherInvestmentPlansQuestionsId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[ExistingOtherInvestments] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TPreExist__Concu__2EE5E349] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TPreExistingOtherInvestmentPlansQuestions_CRMContactId] ON [dbo].[TPreExistingOtherInvestmentPlansQuestions] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
