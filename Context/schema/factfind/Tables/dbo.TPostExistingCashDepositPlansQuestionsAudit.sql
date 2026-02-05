CREATE TABLE [dbo].[TPostExistingCashDepositPlansQuestionsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[NonDisclosure] [bit] NULL,
[CRMContactId] [int] NOT NULL,
[PostExistingCashDepositPlansQuestionsId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TPostExis__Concu__00B50445] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPostExistingCashDepositPlansQuestionsAudit] ADD CONSTRAINT [PK_TPostExistingCashDepositPlansQuestionsAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
