CREATE TABLE [dbo].[TValPortalSetupAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[RefProdProviderId] [int] NOT NULL,
[UserName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Password] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Password2] [varbinary] (4000) NULL,
[Passcode] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ShowHowToScreen] [bit] NOT NULL CONSTRAINT [DF_TValPortalSetupAudit_ShowHowToScreen] DEFAULT ((1)),
[CreatedDate] [datetime] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValPortalSetupAudit_ConcurrencyId] DEFAULT ((1)),
[ValPortalSetupId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TValPortalSetupAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TValPortalSetupAudit] ADD CONSTRAINT [PK_TValPortalSetupAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
