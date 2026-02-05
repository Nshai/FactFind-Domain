CREATE TABLE [dbo].[TLifeCoverAndCic]
(
[LifeCoverAndCicId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLifeCoverAndCic_ConcurrencyId] DEFAULT ((1)),
[CRMContactId] [int] NOT NULL,
[IsDebtCleared] [bit] NULL,
[IsCicMaintainable] [bit] NULL,
[IsLifeMaintainable] [bit] NULL,
[ImpactOnYou] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[ImpactOnDependants] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[HowToAddress] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[NotReviewingReason] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[IsFixedProtectionPremium] [bit] NULL
)
GO
ALTER TABLE [dbo].[TLifeCoverAndCic] ADD CONSTRAINT [PK_TLifeCoverAndCic] PRIMARY KEY NONCLUSTERED  ([LifeCoverAndCicId])
GO
CREATE NONCLUSTERED INDEX [IX_TLifeCoverAndCic_CRMContactId] ON [dbo].[TLifeCoverAndCic] ([CRMContactId])
GO
