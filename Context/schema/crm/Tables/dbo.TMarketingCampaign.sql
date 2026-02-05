CREATE TABLE [dbo].[TMarketingCampaign]
(
[MarketingCampaignId] [int] NOT NULL IDENTITY(1, 1),
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
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMarketingCampaign_ConcurrencyId] DEFAULT ((1)),
[TrackOpen] [bit] NULL,
[TrackClicks] [bit] NULL,
[TrackGoogleAnalytics] [bit] NULL
)
GO
ALTER TABLE [dbo].[TMarketingCampaign] ADD CONSTRAINT [PK_TMarketingCampaign] PRIMARY KEY NONCLUSTERED  ([MarketingCampaignId]) WITH (FILLFACTOR=80)
GO
