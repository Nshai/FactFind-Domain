CREATE TABLE [dbo].[TBuildingAndContentsProtection]
(
[BuildingAndContentsProtectionId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TBuildingAndContentsProtection_ConcurrencyId] DEFAULT ((1)),
[CRMContactId] [int] NOT NULL,
[IsCoverSufficient] [bit] NULL,
[AnyBuyToLet] [bit] NULL,
[IsBtlCoverSufficient] [bit] NULL,
[HowToAddress] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[WhenToReview] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[NotReviewingReason] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[AnyExistingProvision] [bit] NULL,
[AnyExistingBuildingProvision] [bit] NULL,
[AnyExistingContentsProvision] [bit] NULL
)
GO
ALTER TABLE [dbo].[TBuildingAndContentsProtection] ADD CONSTRAINT [PK_TBuildingAndContentsProtection] PRIMARY KEY NONCLUSTERED  ([BuildingAndContentsProtectionId])
GO
