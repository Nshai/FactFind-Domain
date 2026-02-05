CREATE TABLE [dbo].[TBuildingAndContentsProtectionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[IsCoverSufficient] [bit] NULL,
[AnyBuyToLet] [bit] NULL,
[IsBtlCoverSufficient] [bit] NULL,
[HowToAddress] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[WhenToReview] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[NotReviewingReason] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[BuildingAndContentsProtectionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TBuildingAndContentsProtectionAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[AnyExistingProvision] [bit] NULL,
[AnyExistingBuildingProvision] [bit] NULL,
[AnyExistingContentsProvision] [bit] NULL
)
GO
ALTER TABLE [dbo].[TBuildingAndContentsProtectionAudit] ADD CONSTRAINT [PK_TBuildingAndContentsProtectionAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
