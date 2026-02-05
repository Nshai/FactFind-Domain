CREATE TABLE [dbo].[TMultiTie]
(
[MultiTieId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[RefProdProviderId] [int] NOT NULL,
[RefPlanType2ProdSubTypeId] [int] NOT NULL,
[MultiTieConfigId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMultiTie_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TMultiTie] ADD CONSTRAINT [PK_TMultiTie] PRIMARY KEY NONCLUSTERED  ([MultiTieId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TMultiTie_IndigoClientId_RefPlanType2ProdSubTypeId] ON [dbo].[TMultiTie] ([IndigoClientId], [RefPlanType2ProdSubTypeId])
GO
CREATE NONCLUSTERED INDEX [IX_TMultiTie_IndigoClientId_MultiTieConfigId_INCL] ON [dbo].[TMultiTie] ([IndigoClientId], [MultiTieConfigId]) INCLUDE ([RefProdProviderId])
GO
CREATE NONCLUSTERED INDEX IX_TMultiTie_MultiTieConfigId ON [dbo].[TMultiTie] ([MultiTieConfigId]) INCLUDE ([MultiTieId],[RefPlanType2ProdSubTypeId])
GO
CREATE NONCLUSTERED INDEX IX_TMultiTie_RefPlanType2ProdSubTypeId_MultiTieConfigId ON [dbo].[TMultiTie] ([RefPlanType2ProdSubTypeId],[MultiTieConfigId]) 
GO
