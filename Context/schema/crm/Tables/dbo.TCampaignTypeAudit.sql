CREATE TABLE [dbo].[TCampaignTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[IndigoClientId] [int] NOT NULL,
[CampaignType] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ArchiveFG] [bit] NOT NULL CONSTRAINT [DF_TCampaignTypeAudit_ArchiveFG] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCampaignTypeAudit_ConcurrencyId] DEFAULT ((1)),
[CampaignTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TCampaignTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TCampaignTypeAudit] ADD CONSTRAINT [PK_TCampaignTypeAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
