CREATE TABLE [dbo].[TIncomeProtection]
(
[IncomeProtectionId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIncomeProtection_ConcurrencyId] DEFAULT ((1)),
[CRMContactId] [int] NOT NULL,
[IsDebtMaintainable] [bit] NULL,
[IsLifestyleMaintainable] [bit] NULL,
[ImpactOnYou] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[ImpactOnDependants] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[HowToAddress] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[NotReviewingReason] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TIncomeProtection] ADD CONSTRAINT [PK_TIncomeProtection] PRIMARY KEY NONCLUSTERED  ([IncomeProtectionId])
GO
