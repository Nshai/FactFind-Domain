CREATE TABLE [dbo].[TOpportunityCustomer]
(
[OpportunityCustomerId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[OpportunityId] [int] NOT NULL,
[PartyId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TOpportunityCustomer_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TOpportunityCustomer] ADD CONSTRAINT [PK_TOpportunityCustomer] PRIMARY KEY NONCLUSTERED  ([OpportunityCustomerId])
GO
CREATE NONCLUSTERED INDEX [IX_TOpportunityCustomer_OpportunityId] ON [dbo].[TOpportunityCustomer] ([OpportunityId])
GO
CREATE NONCLUSTERED INDEX [IX_TOpportunityCustomer_PartyId] ON [dbo].[TOpportunityCustomer] ([PartyId])
GO
ALTER TABLE [dbo].[TOpportunityCustomer] ADD CONSTRAINT [FK_TOpportunityCustomer_TOpportunity] FOREIGN KEY ([OpportunityId]) REFERENCES [dbo].[TOpportunity] ([OpportunityId])
GO
ALTER TABLE [dbo].[TOpportunityCustomer] ADD CONSTRAINT [FK_TOpportunityCustomer_TCRMContact] FOREIGN KEY ([PartyId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
