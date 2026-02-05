CREATE TABLE [dbo].[TMarketingCampaignRecipient]
(
[MarketingCampaignRecipientId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[MarketingCampaignId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[Name] [varchar] (250) COLLATE Latin1_General_CI_AS NULL,
[EmailAddress] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[MessageId] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[DateSent] [datetime] NULL,
[DateOpened] [datetime] NULL,
[DateClicked] [datetime] NULL,
[DateBounced] [datetime] NULL,
[DateUnsubscribed] [datetime] NULL,
[ClickCount] [int] NOT NULL CONSTRAINT [DF__TMarketin__Click__74E4F594] DEFAULT ((0)),
[OpenCount] [int] NOT NULL CONSTRAINT [DF__TMarketin__OpenC__75D919CD] DEFAULT ((0)),
[IsIncluded] [bit] NOT NULL CONSTRAINT [DF__TMarketin__IsInc__7F7C7980] DEFAULT ((0)),
[Status] [int] NULL,
[EmailHtml] [varchar] (max) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TMarketingCampaignRecipient] ADD CONSTRAINT [PK_TEmailCampaignRecipient2] PRIMARY KEY CLUSTERED  ([MarketingCampaignRecipientId])
GO
CREATE NONCLUSTERED INDEX [IX_TMarketingCampaignRecipient_MessageId] ON [dbo].[TMarketingCampaignRecipient] ([MessageId])
GO
CREATE NONCLUSTERED INDEX [IDX_TMarketingCampaignRecipient_TenantId_MarketingCampaignId]
ON [dbo].[TMarketingCampaignRecipient] ([TenantId],[MarketingCampaignId])
INCLUDE ([MarketingCampaignRecipientId],[CRMContactId],[IsIncluded])
GO
CREATE NONCLUSTERED INDEX [IDX_TMarketingCampaignRecipient_TenantId_MarketingCampaignId_DateOpened_DateBounced_DateClicked]
ON [dbo].[TMarketingCampaignRecipient] ([TenantId],[MarketingCampaignId],[DateOpened],[DateBounced],[DateClicked])
INCLUDE ([CRMContactId])
GO 
