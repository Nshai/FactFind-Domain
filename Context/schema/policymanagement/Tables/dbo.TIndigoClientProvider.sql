CREATE TABLE [dbo].[TIndigoClientProvider]
(
[IndigoClientProviderId] [int] NOT NULL IDENTITY(1, 1),
[RefProdProviderId] [int] NULL,
[IndigoClientId] [int] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefIndCli_ConcurrencyId_3__63] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TIndigoClientProvider] ADD CONSTRAINT [PK_TRefIndClientProvider_4__63] PRIMARY KEY NONCLUSTERED  ([IndigoClientProviderId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TIndigoClientProvider_RefProdProviderId] ON [dbo].[TIndigoClientProvider] ([RefProdProviderId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TIndigoClientProvider] ADD CONSTRAINT [FK_TIndigoClientProvider_RefProdProviderId_RefProdProviderId] FOREIGN KEY ([RefProdProviderId]) REFERENCES [dbo].[TRefProdProvider] ([RefProdProviderId])
GO
