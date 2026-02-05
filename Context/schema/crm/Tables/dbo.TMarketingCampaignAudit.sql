CREATE TABLE [dbo].[TMarketingCampaignAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[MarketingCampaignId] [int] NOT NULL,
[Name] [varchar] (500) COLLATE Latin1_General_CI_AS NOT NULL,
[SenderEmail] [varchar] (500) COLLATE Latin1_General_CI_AS NOT NULL,
[SenderName] [varchar] (500) COLLATE Latin1_General_CI_AS NOT NULL,
[Subject] [varchar] (1000) COLLATE Latin1_General_CI_AS NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[CampaignSendingOption] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[TenantId] [int] NOT NULL,
[TemplateId] [int] NULL,
[Reportid] [int] NULL,
[RecipientCount] [int] NULL,
[CampaignSendDate] [datetime] NULL,
[ConcurrencyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TMarketingCampaignAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[TrackOpen] [bit] NULL,
[TrackClicks] [bit] NULL,
[TrackGoogleAnalytics] [bit] NULL
)
GO
ALTER TABLE [dbo].[TMarketingCampaignAudit] ADD CONSTRAINT [PK_TMarketingCampaignAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
