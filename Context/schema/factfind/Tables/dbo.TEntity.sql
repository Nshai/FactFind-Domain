CREATE TABLE [dbo].[TEntity]
(
[EntityId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[Descriptor] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[DataStore] [varchar] (16) COLLATE Latin1_General_CI_AS NULL,
[Type] [varchar] (16) COLLATE Latin1_General_CI_AS NULL,
[Cols] [tinyint] NULL,
[Path] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[OriginalPath] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[NavigationItemId] [int] NULL,
[PdfHide] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEntity_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TEntity] ADD CONSTRAINT [PK_TEntity] PRIMARY KEY NONCLUSTERED  ([EntityId]) WITH (FILLFACTOR=80)
GO
