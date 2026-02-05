CREATE TABLE [dbo].[TPostExistingMoneyPurchasePlansQuestions]
(
[PostExistingMoneyPurchasePlansQuestionsId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[SSPContractedOut] [bit] NULL,
[NonDisclosure] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TPostExis__Concu__2374309D] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TPostExistingMoneyPurchasePlansQuestions_CRMContactId] ON [dbo].[TPostExistingMoneyPurchasePlansQuestions] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
