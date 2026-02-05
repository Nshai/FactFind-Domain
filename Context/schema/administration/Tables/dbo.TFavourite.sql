CREATE TABLE [dbo].[TFavourite]
(
[FavouriteId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (255)  NULL,
[UserId] [int] NOT NULL,
[URL] [varchar] (255)  NULL,
[ParentId] [int] NULL,
[HomePageFG] [bit] NOT NULL CONSTRAINT [DF_TFavourite_HomePageFG] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFavourite_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFavourite] ADD CONSTRAINT [PK_TFavourite] PRIMARY KEY NONCLUSTERED  ([FavouriteId])
GO
CREATE CLUSTERED INDEX [IDX1_TFavourite_UserId] ON [dbo].[TFavourite] ([UserId])
GO
ALTER TABLE [dbo].[TFavourite] WITH CHECK ADD CONSTRAINT [FK_TFavourite_UserId_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[TUser] ([UserId])
GO
