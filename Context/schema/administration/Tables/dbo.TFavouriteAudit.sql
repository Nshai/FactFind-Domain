CREATE TABLE [dbo].[TFavouriteAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[UserId] [int] NOT NULL,
[URL] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ParentId] [int] NULL,
[HomePageFG] [bit] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[FavouriteId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFavourite_StampDateTime_1__55] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFavouriteAudit] ADD CONSTRAINT [PK_TFavouriteAudit_2__55] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TFavouriteAudit_FavouriteId_ConcurrencyId] ON [dbo].[TFavouriteAudit] ([FavouriteId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
