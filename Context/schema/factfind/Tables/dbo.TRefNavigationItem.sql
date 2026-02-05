CREATE TABLE [dbo].[TRefNavigationItem]
(
[RefNavigationItemId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefNavigationItem_ConcurrencyId] DEFAULT ((0)),
[Name] [varchar] (64) COLLATE Latin1_General_CI_AS NOT NULL,
[XmlId] [varchar] (64) COLLATE Latin1_General_CI_AS NOT NULL
)
GO
ALTER TABLE [dbo].[TRefNavigationItem] ADD CONSTRAINT [PK_TRefNavigationItem] PRIMARY KEY CLUSTERED  ([RefNavigationItemId])
GO
