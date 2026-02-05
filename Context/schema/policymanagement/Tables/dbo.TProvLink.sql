CREATE TABLE [dbo].[TProvLink]
(
[ProvLinkId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefProdProviderId] [int] NULL,
[LinkedToId] [int] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TProvLink_ConcurrencyId_1__63] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TProvLink] ADD CONSTRAINT [PK_TProvLink_2__63] PRIMARY KEY NONCLUSTERED  ([ProvLinkId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TProvLink_LinkedToId] ON [dbo].[TProvLink] ([LinkedToId]) WITH (FILLFACTOR=80)
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_TProvLink_SpCustomProvStateSearchv1_2] ON [dbo].[TProvLink] ([LinkedToId], [RefProdProviderId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TProvLink_RefProdProviderId] ON [dbo].[TProvLink] ([RefProdProviderId]) WITH (FILLFACTOR=80)
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_TProvLink_SpCustomProvStateSearchv1_1] ON [dbo].[TProvLink] ([RefProdProviderId], [LinkedToId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TProvLink] ADD CONSTRAINT [FK_TProvLink_LinkedToId_RefProdProviderId] FOREIGN KEY ([LinkedToId]) REFERENCES [dbo].[TRefProdProvider] ([RefProdProviderId])
GO
ALTER TABLE [dbo].[TProvLink] ADD CONSTRAINT [FK_TProvLink_RefProdProviderId_RefProdProviderId] FOREIGN KEY ([RefProdProviderId]) REFERENCES [dbo].[TRefProdProvider] ([RefProdProviderId])
GO
