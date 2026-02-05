CREATE TABLE [dbo].[TCampaignDataAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CampaignId] [int] NOT NULL,
[CampaignChannelId] [int] NULL,
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Cost] [money] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCampaignDataAudit_ConcurrencyId] DEFAULT ((1)),
[CampaignDataId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TCampaignDataAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
MigrationRef varchar(255) null
)
GO
ALTER TABLE [dbo].[TCampaignDataAudit] ADD CONSTRAINT [PK_TCampaignDataAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
