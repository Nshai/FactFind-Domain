CREATE TABLE [dbo].[TValGating]
(
[ValGatingId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ImplementationCode] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[RefProdProviderId] [int] NOT NULL,
[RefPlanTypeId] [int] NOT NULL,
[ProdSubTypeId] [int] NULL,
[OrigoProductType] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[OrigoProductVersion] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ValuationXSLId] [int] NULL,
[ProviderPlanTypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValGating_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TValGating] ADD CONSTRAINT [PK_TValGating] PRIMARY KEY NONCLUSTERED  ([ValGatingId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TvalGating_RefProdProviderId] ON [dbo].[TValGating] ([RefProdProviderId])
GO
CREATE NONCLUSTERED INDEX [IX_INCL_TValGating_RefProdProviderId] ON [dbo].[TValGating] ([RefProdProviderId]) INCLUDE ([OrigoProductType], [OrigoProductVersion], [ProdSubTypeId], [RefPlanTypeId], [ValGatingId])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_TValGating_refprodproviderid_refplantypeid_prodsubtypeid] ON [dbo].[TValGating] ([RefProdProviderId], [RefPlanTypeId], [ProdSubTypeId])
GO
