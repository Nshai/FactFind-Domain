CREATE TABLE [dbo].[TValPortalSetup]
(
[ValPortalSetupId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CRMContactId] [int] NOT NULL,
[RefProdProviderId] [int] NOT NULL,
[UserName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Password] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Password2] [varbinary] (4000) NULL,
[Passcode] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ShowHowToScreen] [bit] NOT NULL CONSTRAINT [DF_TValPortalSetup_ShowHowToScreen] DEFAULT ((1)),
[CreatedDate] [datetime] NULL CONSTRAINT [DF_TValPortalSetup_CreatedDate] DEFAULT (getdate()),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValPortalSetup_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TValPortalSetup] ADD CONSTRAINT [PK_TValPortalSetup] PRIMARY KEY CLUSTERED  ([ValPortalSetupId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX IX_TValPortalSetup_RefProdProviderId ON [dbo].[TValPortalSetup] ([RefProdProviderId]) INCLUDE ([ValPortalSetupId],[CRMContactId])
GO
CREATE NONCLUSTERED INDEX IX_TValPortalSetup_CRMContactId_RefProdProviderId  ON [dbo].[TValPortalSetup] ([CRMContactId],[RefProdProviderId]) INCLUDE ([ValPortalSetupId])
GO