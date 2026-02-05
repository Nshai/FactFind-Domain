CREATE TABLE [dbo].[TMenuNodeRestrictedURLItem]
(
[MenuNodeRestrictedURLItemId] [int] NOT NULL IDENTITY(1, 1),
[MenuNodeID] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMenuNodeRestrictedURLItem_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TMenuNodeRestrictedURLItem] ADD CONSTRAINT [PK_TMenuNodeRestrictedURLItem] PRIMARY KEY CLUSTERED  ([MenuNodeRestrictedURLItemId])
GO
ALTER TABLE [dbo].[TMenuNodeRestrictedURLItem] ADD CONSTRAINT [FK_TMenuNodeRestrictedURLItem_nio_MenuNode] FOREIGN KEY ([MenuNodeID]) REFERENCES [dbo].[nio_MenuNode] ([MenuNodeID])
GO
