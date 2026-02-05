CREATE TABLE [dbo].[TRefProdProviderPlanType]
(
[RefProdProviderPlanTypeId] [int] NOT NULL IDENTITY(1, 1),
[RefProdProviderId] [int] NOT NULL,
[RefPlanTypeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefProdProviderPlanType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefProdProviderPlanType] ADD CONSTRAINT [PK_TRefProdProviderPlanType] PRIMARY KEY NONCLUSTERED  ([RefProdProviderPlanTypeId])
GO
CREATE NONCLUSTERED INDEX [IDX_TRefProdProviderPlanType_RefPlanTypeId] ON [dbo].[TRefProdProviderPlanType] ([RefPlanTypeId])
GO
CREATE NONCLUSTERED INDEX [IDX_TRefProdProviderPlanType_RefProdProviderId] ON [dbo].[TRefProdProviderPlanType] ([RefProdProviderId])
GO
ALTER TABLE [dbo].[TRefProdProviderPlanType] WITH CHECK ADD CONSTRAINT [FK_TRefProdProviderPlanType_RefPlanTypeId_RefPlanTypeId] FOREIGN KEY ([RefPlanTypeId]) REFERENCES [dbo].[TRefPlanType] ([RefPlanTypeId])
GO
ALTER TABLE [dbo].[TRefProdProviderPlanType] ADD CONSTRAINT [FK_TRefProdProviderPlanType_RefProdProviderId_RefProdProviderId] FOREIGN KEY ([RefProdProviderId]) REFERENCES [dbo].[TRefProdProvider] ([RefProdProviderId])
GO
