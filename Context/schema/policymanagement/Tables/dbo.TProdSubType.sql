CREATE TABLE [dbo].[TProdSubType]
(
[ProdSubTypeId] [int] NOT NULL IDENTITY(1, 1),
[QuoteProductId] [int] NULL,
[NBProductId] [int] NULL,
[OrigoTableName] [varchar] (255)  NULL,
[ProdSubTypeName] [varchar] (255)  NULL,
[QuoteSubRef] [varchar] (255)  NULL,
[NBSubRef] [varchar] (255)  NULL,
[ClientSummary] [varchar] (2000)  NULL,
[ProductSummary] [varchar] (2000)  NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TProdSubType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TProdSubType] ADD CONSTRAINT [PK_TProdSubType] PRIMARY KEY CLUSTERED  ([ProdSubTypeId])
GO
CREATE NONCLUSTERED INDEX [IDX_TProdSubType_NBProductId] ON [dbo].[TProdSubType] ([NBProductId])
GO
CREATE NONCLUSTERED INDEX [IDX_TProdSubType_QuoteProductId] ON [dbo].[TProdSubType] ([QuoteProductId])
GO
ALTER TABLE [dbo].[TProdSubType] WITH CHECK ADD CONSTRAINT [FK_TProdSubType_NBProductId_ProductId] FOREIGN KEY ([NBProductId]) REFERENCES [dbo].[TProduct] ([ProductId])
GO
ALTER TABLE [dbo].[TProdSubType] WITH CHECK ADD CONSTRAINT [FK_TProdSubType_QuoteProductId_ProductId] FOREIGN KEY ([QuoteProductId]) REFERENCES [dbo].[TProduct] ([ProductId])
GO
