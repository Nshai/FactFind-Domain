CREATE TABLE [dbo].[TPreExistingOtherInvestmentPlansQuestionsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ExistingOtherInvestments] [bit] NULL,
[CRMContactId] [int] NOT NULL,
[PreExistingOtherInvestmentPlansQuestionsId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TPreExist__Concu__029D4CB7] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPreExistingOtherInvestmentPlansQuestionsAudit] ADD CONSTRAINT [PK_TPreExistingOtherInvestmentPlansQuestionsAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
