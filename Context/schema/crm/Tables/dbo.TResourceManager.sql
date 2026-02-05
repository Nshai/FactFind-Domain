CREATE TABLE [dbo].[TResourceManager]
(
[ResourceManagerId] [int] NOT NULL IDENTITY(1, 1),
[ResourceListId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[DefaultFG] [bit] NOT NULL CONSTRAINT [DF_TResourceManager_DefaultFG] DEFAULT ((0)),
[IndClientId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TResourceManager_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TResourceManager] ADD CONSTRAINT [PK_TResourceManager] PRIMARY KEY NONCLUSTERED  ([ResourceManagerId])
GO
CREATE NONCLUSTERED INDEX [IDX_TResourceManager_CRMContactId] ON [dbo].[TResourceManager] ([CRMContactId])
GO
CREATE NONCLUSTERED INDEX [IDX_TResourceManager_ResourceListId] ON [dbo].[TResourceManager] ([ResourceListId])
GO
ALTER TABLE [dbo].[TResourceManager] WITH CHECK ADD CONSTRAINT [FK_TResourceManager_CRMContactId_CRMContactId] FOREIGN KEY ([CRMContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
ALTER TABLE [dbo].[TResourceManager] ADD CONSTRAINT [FK_TResourceManager_ResourceListId_ResourceListId] FOREIGN KEY ([ResourceListId]) REFERENCES [dbo].[TResourceList] ([ResourceListId])
GO
