CREATE TABLE [dbo].[TOpportunity]
(
[OpportunityId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[IndigoClientId] [int] NOT NULL,
[OpportunityTypeId] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[Amount] [money] NULL,
[Probability] [decimal] (5, 2) NULL,
[PractitionerId] [int] NULL,
[IntroducerId] [int] NULL,
[IsClosed] [bit] NOT NULL CONSTRAINT [DF_TOpportunity_IsClosed] DEFAULT ((0)),
[ClosedDate] [datetime] NULL,
[CampaignDataId] [int] NULL,
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[SequentialRefLegacy] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[SequentialRef]  AS (case when [SequentialRefLegacy] IS NULL then 'IOO'+right(replicate('0',(8))+CONVERT([varchar],[OpportunityId]),(8)) collate Latin1_General_CI_AS else [SequentialRefLegacy] end),
[AdviserAssignedByUserId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TOpportunity_ConcurrencyId] DEFAULT ((1)),
[ClientAssetValue] [decimal] (18, 2) NULL,
[PropositionTypeId] [int] Null,
[TargetClosedDate] [datetime] NULL,
[OpportunityMigrationRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[AmountOngoing] [money] NULL
)
GO
ALTER TABLE [dbo].[TOpportunity] ADD CONSTRAINT [PK_TOpportunity] PRIMARY KEY CLUSTERED  ([OpportunityId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_IndClientId] ON [dbo].[TOpportunity] ([IndigoClientId])
GO
CREATE NONCLUSTERED INDEX [IX_TOpportunity_IndigoClientId] ON [dbo].[TOpportunity] ([IndigoClientId])
GO
CREATE NONCLUSTERED INDEX [IX_OpportunityTypeId] ON [dbo].[TOpportunity] ([OpportunityTypeId])
GO
CREATE NONCLUSTERED INDEX [IX_TOpportunity_OpportunityTypeId] ON [dbo].[TOpportunity] ([OpportunityTypeId])
GO
CREATE NONCLUSTERED INDEX IX_INCL_TOpportunity_IndigoClientId_PractitionerId ON [dbo].[TOpportunity] ([IndigoClientId],[PractitionerId]) INCLUDE ([OpportunityId],[OpportunityTypeId],[CreatedDate],[Amount],[Probability],[ClosedDate],[ClientAssetValue],[PropositionTypeId])
go
CREATE NONCLUSTERED INDEX IX_TOpportunity_CreatedDate ON [dbo].[TOpportunity] ([CreatedDate]) INCLUDE ([Amount],[PractitionerId])
GO
CREATE NONCLUSTERED INDEX Ix_TOpportunity_IndigoClientId_IsClosed ON [dbo].[TOpportunity] ([IndigoClientId],[IsClosed]) INCLUDE ([OpportunityId],[Identifier],[SequentialRefLegacy])
GO
CREATE NONCLUSTERED INDEX [IX_TOpportunity_CampaignDataId] ON [dbo].[TOpportunity] ([CampaignDataId]) with (sort_in_tempdb = on)
GO

