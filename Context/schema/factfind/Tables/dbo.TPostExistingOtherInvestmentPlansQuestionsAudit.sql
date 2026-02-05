CREATE TABLE [dbo].[TPostExistingOtherInvestmentPlansQuestionsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[NonDisclosure] [bit] NULL,
[CRMContactId] [int] NOT NULL,
[PostExistingOtherInvestmentPlansQuestionsId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TPostExis__Concu__04859529] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPostExistingOtherInvestmentPlansQuestionsAudit] ADD CONSTRAINT [PK_TPostExistingOtherInvestmentPlansQuestionsAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
