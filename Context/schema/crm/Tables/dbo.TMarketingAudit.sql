CREATE TABLE [dbo].[TMarketingAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[Telephone] [bit] NULL,
[Mail] [bit] NULL,
[Email] [bit] NULL,
[Sms] [bit] NULL,
[OtherTelephone] [bit] NULL,
[OtherMail] [bit] NULL,
[OtherEmail] [bit] NULL,
[OtherSms] [bit] NULL,
[MarketingId] [int] NULL,
[StampAction] [char] (1)  NOT NULL,
[StampDateTime] [datetime] NOT NULL CONSTRAINT [DF_TMarketingAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255)  NOT NULL,
[AccessibleFormat] [varchar] (50)  NULL,
[DeliveryMethod] [varchar] (50)  NULL,
[SocialMedia] [bit] NULL CONSTRAINT [DF_TMarketingAudit_SocialMedia] DEFAULT ((0)),
[OtherSocialMedia] [bit] NULL CONSTRAINT [DF_TMarketingAudit_OtherSocialMedia] DEFAULT ((0)),
[MigrationRef] varchar(255) null,
[CanContactForMarketing] [tinyint] NULL,
[ConsentDate] [datetime] NULL,
[AutomatedCalls] [bit] NULL,
[OtherAutomatedCalls] [bit] NULL,
[PFP] [bit] NULL,
[OtherPFP] [bit] NULL
)
GO
ALTER TABLE [dbo].[TMarketingAudit] ADD CONSTRAINT [PK_TMarketingAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
