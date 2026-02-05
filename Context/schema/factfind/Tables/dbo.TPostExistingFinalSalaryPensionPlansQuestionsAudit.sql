CREATE TABLE [dbo].[TPostExistingFinalSalaryPensionPlansQuestionsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[NonDisclosure] [bit] NULL,
[CRMContactId] [int] NOT NULL,
[PostExistingFinalSalaryPensionPlansQuestionsId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TPostExis__Concu__7913E27D] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPostExistingFinalSalaryPensionPlansQuestionsAudit] ADD CONSTRAINT [PK_TPostExistingFinalSalaryPensionPlansQuestionsAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
