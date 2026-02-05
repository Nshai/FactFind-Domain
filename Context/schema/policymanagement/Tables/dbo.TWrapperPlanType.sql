CREATE TABLE [dbo].[TWrapperPlanType]
(
[WrapperPlanTypeId] [int] NOT NULL IDENTITY(1, 1),
[WrapperProviderId] [int] NOT NULL,
[RefPlanType2ProdSubTypeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TWrapperPlanType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TWrapperPlanType] ADD CONSTRAINT [PK_TWrapperPlanType] PRIMARY KEY NONCLUSTERED  ([WrapperPlanTypeId]) WITH (FILLFACTOR=90)
GO
CREATE NONCLUSTERED INDEX [IX_TWrapperPlanType_RefPlanType2ProdSubTypeId_WrapperProviderId] ON [dbo].[TWrapperPlanType] ([RefPlanType2ProdSubTypeId], [WrapperProviderId])
GO
CREATE CLUSTERED INDEX [IX_TWrapperPlanType] ON [dbo].[TWrapperPlanType] ([WrapperPlanTypeId], [RefPlanType2ProdSubTypeId], [WrapperProviderId])
GO
ALTER TABLE [dbo].[TWrapperPlanType] ADD CONSTRAINT [FK_TWrapperPlanType_TRefPlanType2ProdSubType] FOREIGN KEY ([RefPlanType2ProdSubTypeId]) REFERENCES [dbo].[TRefPlanType2ProdSubType] ([RefPlanType2ProdSubTypeId])
GO
ALTER TABLE [dbo].[TWrapperPlanType] ADD CONSTRAINT [FK_TWrapperPlanType_TWrapperProvider] FOREIGN KEY ([WrapperProviderId]) REFERENCES [dbo].[TWrapperProvider] ([WrapperProviderId])
GO
CREATE NONCLUSTERED INDEX IX_TWrapperPlanType_WrapperProviderId ON [dbo].[TWrapperPlanType] ([WrapperProviderId]) INCLUDE ([RefPlanType2ProdSubTypeId])
GO