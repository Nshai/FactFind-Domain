CREATE TABLE [dbo].[TOpportunityBinder]
(
[OpportunityBinderId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[BinderId] [int] NOT NULL,
[OpportunityId] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TOpportunityBinder_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TOpportunityBinder] ADD CONSTRAINT [PK_TOpportunityBinder] PRIMARY KEY NONCLUSTERED  ([OpportunityBinderId])
GO
CREATE CLUSTERED INDEX [CLX_TOpportunityBinder_OpportunityId] ON [dbo].[TOpportunityBinder] ([OpportunityId])
GO
CREATE NONCLUSTERED INDEX [IDX_TOpportunityBinder_BinderId] ON [dbo].[TOpportunityBinder] ([BinderId])
