CREATE TABLE [dbo].[TMarketingCampaignRecipientAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[MarketingCampaignRecipientId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[MarketingCampaignId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[MessageId] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[DateSent] [datetime] NULL,
[DateOpened] [datetime] NULL,
[DateClicked] [datetime] NULL,
[DateBounced] [datetime] NULL,
[DateUnsubscribed] [datetime] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_dbo.TMarketingCampaignRecipientAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsIncluded] [bit] NOT NULL CONSTRAINT [DF__TMarketin__IsInc__F79BC0E] DEFAULT ((0)),
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[EmailAddress] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ClickCount] [int] NOT NULL CONSTRAINT [DF__TMarketin__Click__5FE4B590] DEFAULT ((0)),
[OpenCount] [int] NOT NULL CONSTRAINT [DF__TMarketin__OpenC__367E9B41] DEFAULT ((0)),
[Status] [int] NULL,
[EmailHtml] [varchar] (max) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TMarketingCampaignRecipientAudit] ADD CONSTRAINT [PK_TMarketingCampaignRecipientAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
