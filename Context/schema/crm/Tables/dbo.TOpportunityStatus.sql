CREATE TABLE [dbo].[TOpportunityStatus]
(
[OpportunityStatusId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[OpportunityStatusName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NOT NULL,
[InitialStatusFG] [bit] NOT NULL CONSTRAINT [DF_TOpportunityStatus_InitialStatusFG] DEFAULT ((0)),
[ArchiveFG] [bit] NOT NULL CONSTRAINT [DF_TOpportunityStatus_ArchiveFG] DEFAULT ((0)),
[AutoCloseOpportunityFg] [bit] NOT NULL CONSTRAINT [DF_TOpportunityStatus_AutoCloseOpportunityFg] DEFAULT ((0)),
[OpportunityStatusTypeId] [int] NOT NULL CONSTRAINT [DF_TOpportunityStatus_OpportunityStatusTypeId] DEFAULT ((1)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TOpportunityStatus_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TOpportunityStatus] ADD CONSTRAINT [PK_TOpportunityStatus] PRIMARY KEY CLUSTERED  ([OpportunityStatusId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TOpportunityStatus] ON [dbo].[TOpportunityStatus] ([OpportunityStatusId], [OpportunityStatusName], [IndigoClientId])
GO
