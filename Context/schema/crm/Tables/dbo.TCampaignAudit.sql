CREATE TABLE [dbo].[TCampaignAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CampaignTypeId] [int] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[GroupId] [int] NULL,
[CampaignName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ArchiveFG] [bit] NOT NULL CONSTRAINT [DF_TCampaignAudit_ArchiveFG] DEFAULT ((0)),
[IsOrganisational] [bit] NOT NULL CONSTRAINT [DF_TCampaignAudit_IsOrganisational] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCampaignAudit_ConcurrencyId] DEFAULT ((1)),
[CampaignId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TCampaignAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TCampaignAudit] ADD CONSTRAINT [PK_TCampaignAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
