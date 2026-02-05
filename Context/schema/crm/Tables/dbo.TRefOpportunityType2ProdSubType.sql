CREATE TABLE [dbo].[TRefOpportunityType2ProdSubType]
(
[RefOpportunityType2ProdSubTypeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ProdSubTypeId] [int] NULL,
[OpportunityTypeId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefOpportunityType2ProdSubType_ConcurrencyId] DEFAULT ((1)),
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TRefOpportunityType2ProdSubType_IsArchived] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TRefOpportunityType2ProdSubType] ADD CONSTRAINT [PK_TRefOpportunityType2ProdSubType] PRIMARY KEY NONCLUSTERED  ([RefOpportunityType2ProdSubTypeId]) WITH (FILLFACTOR=90)
GO
CREATE NONCLUSTERED INDEX [IDX_TRefOpportunityType2ProdSubType_ProdSubTypeId] ON [dbo].[TRefOpportunityType2ProdSubType] ([ProdSubTypeId]) WITH (FILLFACTOR=90)
GO
CREATE NONCLUSTERED INDEX [IDX_TRefOpportunityType2ProdSubType_OpportunityTypeId] ON [dbo].[TRefOpportunityType2ProdSubType] ([OpportunityTypeId]) WITH (FILLFACTOR=90)
GO


