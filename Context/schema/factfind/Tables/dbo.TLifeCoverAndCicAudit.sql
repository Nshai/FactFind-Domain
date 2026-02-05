CREATE TABLE [dbo].[TLifeCoverAndCicAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[IsDebtCleared] [bit] NULL,
[IsCicMaintainable] [bit] NULL,
[IsLifeMaintainable] [bit] NULL,
[ImpactOnYou] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[ImpactOnDependants] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[HowToAddress] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[NotReviewingReason] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[LifeCoverAndCicId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TLifeCoverAndCicAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsFixedProtectionPremium] [bit] NULL
)
GO
ALTER TABLE [dbo].[TLifeCoverAndCicAudit] ADD CONSTRAINT [PK_TLifeCoverAndCicAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
