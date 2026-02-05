CREATE TABLE [dbo].[TProduct]
(
[ProductId] [int] NOT NULL IDENTITY(1, 1),
[RequestXmlMappingId] [int] NULL,
[ResponseXmlMappingId] [int] NULL,
[ProductConnectionSettingId] [int] NULL,
[ProdSubTypeId] [int] NULL,
[VersionNumber] [int] NULL,
[ProductName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[ExpiryDate] [datetime] NULL,
[DateUpdated] [datetime] NULL,
[AppDocVersionId] [int] NULL,
[PacId] [int] NULL,
[QVTStageId] [int] NULL,
[NBProductId] [int] NULL,
[Extensible] [char] (10) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TProduct_ConcurrencyId_1__103] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TProduct] ADD CONSTRAINT [PK_TProduct_2__103] PRIMARY KEY NONCLUSTERED  ([ProductId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TProduct_NBProductId] ON [dbo].[TProduct] ([NBProductId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TProduct_PacId] ON [dbo].[TProduct] ([PacId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TProduct_ProdSubTypeId] ON [dbo].[TProduct] ([ProdSubTypeId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TProduct_ProductConnectionSettingId] ON [dbo].[TProduct] ([ProductConnectionSettingId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TProduct_QVTStageId] ON [dbo].[TProduct] ([QVTStageId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TProduct] ADD CONSTRAINT [FK_TProduct_NBProductId_ProductId] FOREIGN KEY ([NBProductId]) REFERENCES [dbo].[TProduct] ([ProductId])
GO
ALTER TABLE [dbo].[TProduct] ADD CONSTRAINT [FK_TProduct_PacId_PacId] FOREIGN KEY ([PacId]) REFERENCES [dbo].[TPac] ([PacId])
GO
ALTER TABLE [dbo].[TProduct] ADD CONSTRAINT [FK_TProduct_ProdSubTypeId_ProdSubTypeId] FOREIGN KEY ([ProdSubTypeId]) REFERENCES [dbo].[TProdSubType] ([ProdSubTypeId])
GO
ALTER TABLE [dbo].[TProduct] ADD CONSTRAINT [FK_TProduct_ProductConnectionSettingId_ProductConnectionSettingId] FOREIGN KEY ([ProductConnectionSettingId]) REFERENCES [dbo].[TProductConnectionSetting] ([ProductConnectionSettingId])
GO
ALTER TABLE [dbo].[TProduct] ADD CONSTRAINT [FK_TProduct_QVTStageId_QVTStageId] FOREIGN KEY ([QVTStageId]) REFERENCES [dbo].[TQVTStage] ([QVTStageId])
GO
