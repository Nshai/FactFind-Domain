CREATE TABLE [dbo].[TPreExistingCashDepositPlansQuestionsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ExistingCashDepositAccounts] [bit] NULL,
[CRMContactId] [int] NOT NULL,
[PreExistingCashDepositPlansQuestionsId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TPreExist__Concu__7ECCBBD3] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPreExistingCashDepositPlansQuestionsAudit] ADD CONSTRAINT [PK_TPreExistingCashDepositPlansQuestionsAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
