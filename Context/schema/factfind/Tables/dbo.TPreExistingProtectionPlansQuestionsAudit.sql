CREATE TABLE [dbo].[TPreExistingProtectionPlansQuestionsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ExistingDeathInServiceBenefits] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ExistingProtection] [bit] NULL,
[CRMContactId] [int] NOT NULL,
[PreExistingProtectionPlansQuestionsId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TPreExist__Concu__7172C0B5] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPreExistingProtectionPlansQuestionsAudit] ADD CONSTRAINT [PK_TPreExistingProtectionPlansQuestionsAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
