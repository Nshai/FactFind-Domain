CREATE TABLE [dbo].[TCampaignSegmentAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CampaignSegmentId] [int] NOT NULL,
[MarketingCampaignId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[SegmentOption] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCampaignSegmentAudit_ConcurrencyId] DEFAULT ((1)),
[SegmentFilters] [xml] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_dbo.TCampaignSegmentAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TCampaignSegmentAudit] ADD CONSTRAINT [PK_TCampaignSegmentAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO