CREATE TABLE [dbo].[TIncomeProtectionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[IsDebtMaintainable] [bit] NULL,
[IsLifestyleMaintainable] [bit] NULL,
[ImpactOnYou] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[ImpactOnDependants] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[HowToAddress] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[NotReviewingReason] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[IncomeProtectionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TIncomeProtectionAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TIncomeProtectionAudit] ADD CONSTRAINT [PK_TIncomeProtectionAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
