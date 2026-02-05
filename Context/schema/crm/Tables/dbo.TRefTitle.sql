CREATE TABLE [dbo].[TRefTitle]
(
[RefTitleId] [int] NOT NULL IDENTITY(1, 1),
[TitleName] [varchar] (128) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefTitle_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefTitle] ADD CONSTRAINT [PK_TRefTitle] PRIMARY KEY CLUSTERED  ([RefTitleId])
GO
