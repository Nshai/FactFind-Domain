CREATE TABLE [dbo].[TCampaignData]
(
[CampaignDataId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CampaignId] [int] NOT NULL,
[CampaignChannelId] [int] NULL,
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Cost] [money] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCampaignData_ConcurrencyId] DEFAULT ((1)),
MigrationRef varchar(255) null
)
GO
ALTER TABLE [dbo].[TCampaignData] ADD CONSTRAINT [PK_TCampaignData] PRIMARY KEY CLUSTERED  ([CampaignDataId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TCampaignData_CampaignId] ON [dbo].[TCampaignData] ([CampaignId])
GO
CREATE NONCLUSTERED INDEX IX_TCampaignData_MigrationRef on [TCampaignData] (MigrationRef,CampaignId)
GO