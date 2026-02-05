CREATE TABLE [dbo].[TOpportunityStatusHistory]
(
[OpportunityStatusHistoryId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[OpportunityId] [int] NOT NULL,
[OpportunityStatusId] [int] NOT NULL,
[DateOfChange] [datetime] NOT NULL,
[ChangedByUserId] [int] NOT NULL,
[CurrentStatusFG] [bit] NOT NULL CONSTRAINT [DF_TOpportunityStatusHistory_CurrentStatusFG] DEFAULT ((1)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TOpportunityStatusHistory_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TOpportunityStatusHistory] ADD CONSTRAINT [PK_TOpportunityStatusHistory] PRIMARY KEY CLUSTERED  ([OpportunityStatusHistoryId])
GO
CREATE NONCLUSTERED INDEX [IDX_TOpportunityStatusHistory_CurrentStatusFG] ON [dbo].[TOpportunityStatusHistory] ([CurrentStatusFG]) INCLUDE ([OpportunityId], [OpportunityStatusId])
GO
CREATE NONCLUSTERED INDEX [IDX_TOpportunityStatusHistory_OpportunityId_CurrentStatusFG] ON [dbo].[TOpportunityStatusHistory] ([OpportunityId], [CurrentStatusFG])
GO
CREATE NONCLUSTERED INDEX [IX_OpportunityId_OpportunityStatusId] ON [dbo].[TOpportunityStatusHistory] ([OpportunityId], [OpportunityStatusId])
GO
CREATE NONCLUSTERED INDEX [IX_TOpportunityStatusHistory_OpportunityId_OpportunityStatusId] ON [dbo].[TOpportunityStatusHistory] ([OpportunityId], [OpportunityStatusId])
GO
CREATE NONCLUSTERED INDEX [IX_TOpportunityStatusHistory_OppertunityStatusId] ON [dbo].[TOpportunityStatusHistory] ([OpportunityStatusId])
GO
