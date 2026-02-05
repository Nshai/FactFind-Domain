CREATE TABLE [dbo].[TPostExistingProtectionPlansQuestionsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[NonDisclosure] [bit] NULL,
[CRMContactId] [int] NOT NULL,
[PostExistingProtectionPlansQuestionsId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TPostExis__Concu__735B0927] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPostExistingProtectionPlansQuestionsAudit] ADD CONSTRAINT [PK_TPostExistingProtectionPlansQuestionsAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
