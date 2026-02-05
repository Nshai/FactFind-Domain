CREATE TABLE [dbo].[TPostExistingMoneyPurchasePlansQuestionsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[SSPContractedOut] [bit] NULL,
[NonDisclosure] [bit] NULL,
[CRMContactId] [int] NOT NULL,
[PostExistingMoneyPurchasePlansQuestionsId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TPostExis__Concu__772B9A0B] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPostExistingMoneyPurchasePlansQuestionsAudit] ADD CONSTRAINT [PK_TPostExistingMoneyPurchasePlansQuestionsAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
