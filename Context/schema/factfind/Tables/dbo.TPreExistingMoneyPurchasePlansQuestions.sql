CREATE TABLE [dbo].[TPreExistingMoneyPurchasePlansQuestions]
(
[PreExistingMoneyPurchasePlansQuestionsId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[ExistingMoneyPurchaseSchemes] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPreExistingMoneyPurchasePlansQuestions_ConcurrencyId] DEFAULT ((1)),
[HasPersonalPensions] [bit] NULL,
[IsPersonalPensionNonDisclosed] [bit] NULL,
[HasAnnuities] [bit] NULL,
[IsAnnuityNonDisclosed] [bit] NULL
)
GO
ALTER TABLE [dbo].[TPreExistingMoneyPurchasePlansQuestions] ADD CONSTRAINT [PK_TPreExistingMoneyPurchasePlansQuestions] PRIMARY KEY NONCLUSTERED  ([PreExistingMoneyPurchasePlansQuestionsId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPreExistingMoneyPurchasePlansQuestions_CRMContactId] ON [dbo].[TPreExistingMoneyPurchasePlansQuestions] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
