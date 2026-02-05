CREATE TABLE [dbo].[TRefPlanType2ProdSubTypeExternalMapping]
(
[RefPlanType2ProdSubTypeExternalMappingId] [int] NOT NULL IDENTITY(1, 1),
[RefPlanType2ProdSubTypeId] [int] NOT NULL,
[RefProdProviderId] [int] NOT NULL,
[ExternalCode] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPlanType2ProdSubTypeExternalMapping_ConcurrencyId] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TRefPlanType2ProdSubTypeExternalMapping] ADD CONSTRAINT [PK_TRefPlanType2ProdSubTypeExternalMapping] PRIMARY KEY CLUSTERED  ([RefPlanType2ProdSubTypeExternalMappingId])
GO
ALTER TABLE [dbo].[TRefPlanType2ProdSubTypeExternalMapping] ADD CONSTRAINT [FK_TRefPlanType2ProdSubTypeExternalMapping_TRefPlanType2ProdSubType] FOREIGN KEY ([RefPlanType2ProdSubTypeId]) REFERENCES [dbo].[TRefPlanType2ProdSubType] ([RefPlanType2ProdSubTypeId])
GO
ALTER TABLE [dbo].[TRefPlanType2ProdSubTypeExternalMapping] ADD CONSTRAINT [FK_TRefPlanType2ProdSubTypeExternalMapping_TRefProdProvider] FOREIGN KEY ([RefProdProviderId]) REFERENCES [dbo].[TRefProdProvider] ([RefProdProviderId])
GO
