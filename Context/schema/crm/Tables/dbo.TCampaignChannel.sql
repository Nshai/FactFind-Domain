CREATE TABLE [dbo].[TCampaignChannel]
(
[CampaignChannelId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[IndigoClientId] [int] NOT NULL,
[CampaignChannel] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ArchiveFg] [bit] NOT NULL CONSTRAINT [DF_TCampaignChannel_ArchiveFg] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCampaignChannel_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TCampaignChannel] ADD CONSTRAINT [PK_TCampaignChannel] PRIMARY KEY CLUSTERED  ([CampaignChannelId]) WITH (FILLFACTOR=80)
GO
