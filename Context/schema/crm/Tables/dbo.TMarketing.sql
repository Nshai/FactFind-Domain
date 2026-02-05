CREATE TABLE [dbo].[TMarketing]
(
[MarketingId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMarketing_ConcurrencyId] DEFAULT ((1)),
[CRMContactId] [int] NOT NULL,
[Telephone] [bit] NULL CONSTRAINT [DF_TMarketing_Telephone] DEFAULT ((0)),
[Mail] [bit] NULL CONSTRAINT [DF_TMarketing_Mail] DEFAULT ((0)),
[Email] [bit] NULL CONSTRAINT [DF_TMarketing_Email] DEFAULT ((0)),
[Sms] [bit] NULL CONSTRAINT [DF_TMarketing_Sms] DEFAULT ((0)),
[OtherTelephone] [bit] NULL CONSTRAINT [DF_TMarketing_TelephoneAnniversary] DEFAULT ((0)),
[OtherMail] [bit] NULL CONSTRAINT [DF_TMarketing_MailAnniversary] DEFAULT ((0)),
[OtherEmail] [bit] NULL CONSTRAINT [DF_TMarketing_EmailAnniversary] DEFAULT ((0)),
[OtherSms] [bit] NULL CONSTRAINT [DF_TMarketing_SmsAnniversary] DEFAULT ((0)),
[AccessibleFormat] [varchar] (50)  NULL,
[DeliveryMethod] [varchar] (50)  NULL,
[SocialMedia] [bit] NULL CONSTRAINT [DF_TMarketing_SocialMedia] DEFAULT ((0)),
[OtherSocialMedia] [bit] NULL CONSTRAINT [DF_TMarketing_OtherSocialMedia] DEFAULT ((0)),
[MigrationRef] varchar(255) NULL,
[CanContactForMarketing] [tinyint] NULL,
[ConsentDate] [datetime] NULL,
[AutomatedCalls] [bit] NULL,
[OtherAutomatedCalls] [bit] NULL,
[PFP] [bit] NULL,
[OtherPFP] [bit] NULL

)
GO
ALTER TABLE [dbo].[TMarketing] ADD CONSTRAINT [PK_TMarketing] PRIMARY KEY CLUSTERED  ([MarketingId])
GO
CREATE NONCLUSTERED INDEX [IDX_TMarketing_CRMContactId] ON [dbo].[TMarketing] ([CRMContactId])
GO
ALTER TABLE [dbo].[TMarketing] ADD CONSTRAINT [FK_TMarketing_TCRMContact] FOREIGN KEY ([CRMContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
ALTER TABLE [dbo].[TMarketing]  ADD CONSTRAINT [DF_TMarketing_AutomatedCalls_DefaultValue] DEFAULT(0) FOR [AutomatedCalls]
GO
ALTER TABLE [dbo].[TMarketing]  ADD CONSTRAINT [DF_TMarketing_OtherAutomatedCalls_DefaultValue] DEFAULT(0) FOR [OtherAutomatedCalls]
GO
ALTER TABLE [dbo].[TMarketing]  ADD CONSTRAINT [DF_TMarketing_PFP_DefaultValue] DEFAULT(0) FOR [PFP]
GO
ALTER TABLE [dbo].[TMarketing]  ADD CONSTRAINT [DF_TMarketing_OtherPFP_DefaultValue] DEFAULT(0) FOR [OtherPFP]
GO
