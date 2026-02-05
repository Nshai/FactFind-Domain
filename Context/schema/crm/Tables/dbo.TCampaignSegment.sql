CREATE TABLE [dbo].[TCampaignSegment]
(
[CampaignSegmentId] [int] NOT NULL IDENTITY(1, 1),
[MarketingCampaignId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[SegmentOption] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCampaignSegment_ConcurrencyId] DEFAULT ((1)),
[SegmentFilters] [xml] NULL
)
GO
ALTER TABLE [dbo].[TCampaignSegment] ADD CONSTRAINT [PK_TCampaignSegment] PRIMARY KEY NONCLUSTERED  ([CampaignSegmentId]) WITH (FILLFACTOR=80)
GO
