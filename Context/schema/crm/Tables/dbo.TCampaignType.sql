CREATE TABLE [dbo].[TCampaignType]
(
[CampaignTypeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[IndigoClientId] [int] NOT NULL,
[CampaignType] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ArchiveFG] [bit] NOT NULL CONSTRAINT [DF_TCampaignType_ArchiveFG] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCampaignType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TCampaignType] ADD CONSTRAINT [PK_TCampaignType] PRIMARY KEY CLUSTERED  ([CampaignTypeId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TCampaignType] ON [dbo].[TCampaignType] ([CampaignTypeId], [CampaignType], [IndigoClientId])
GO
