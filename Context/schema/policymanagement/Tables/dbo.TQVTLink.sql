CREATE TABLE [dbo].[TQVTLink]
(
[QVTLinkId] [int] NOT NULL IDENTITY(1, 1),
[RefProdProviderId] [int] NULL,
[ProductId] [int] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQVTLink_ConcurrencyId_1__63] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TQVTLink] ADD CONSTRAINT [PK_TQVTLink_2__63] PRIMARY KEY NONCLUSTERED  ([QVTLinkId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TQVTLink_ProductId] ON [dbo].[TQVTLink] ([ProductId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TQVTLink_RefProdProviderId] ON [dbo].[TQVTLink] ([RefProdProviderId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TQVTLink] ADD CONSTRAINT [FK_TQVTLink_ProductId_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[TProduct] ([ProductId])
GO
ALTER TABLE [dbo].[TQVTLink] ADD CONSTRAINT [FK_TQVTLink_RefProdProviderId_RefProdProviderId] FOREIGN KEY ([RefProdProviderId]) REFERENCES [dbo].[TRefProdProvider] ([RefProdProviderId])
GO
