CREATE TABLE [dbo].[TCampaign]
(
[CampaignId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CampaignTypeId] [int] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[GroupId] [int] NULL,
[CampaignName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ArchiveFG] [bit] NOT NULL CONSTRAINT [DF_TCampaign_ArchiveFG] DEFAULT ((0)),
[IsOrganisational] [bit] NOT NULL CONSTRAINT [DF_TCampaign_IsOrganisational] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCampaign_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TCampaign] ADD CONSTRAINT [PK_TCampaign] PRIMARY KEY CLUSTERED  ([CampaignId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TCampaign_CampaignTypeId_IndigoClientId] ON [dbo].[TCampaign] ([CampaignTypeId], [IndigoClientId])
GO
