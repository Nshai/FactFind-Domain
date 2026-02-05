CREATE TABLE [dbo].[TPreExistingProtectionPlansQuestions]
(
[PreExistingProtectionPlansQuestionsId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[ExistingDeathInServiceBenefits] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ExistingProtection] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TPreExist__Concu__1DBB5747] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TPreExistingProtectionPlansQuestions_CRMContactId] ON [dbo].[TPreExistingProtectionPlansQuestions] ([CRMContactId])
GO
