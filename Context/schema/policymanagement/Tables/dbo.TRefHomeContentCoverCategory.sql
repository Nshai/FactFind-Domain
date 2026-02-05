CREATE TABLE [dbo].[TRefHomeContentCoverCategory]
(
[RefHomeContentCoverCategoryId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (256) COLLATE Latin1_General_CI_AS NOT NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TRefHomeContentCoverCategory_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefHomeContentCoverCategory_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefHomeContentCoverCategory] ADD CONSTRAINT [PK_TRefHomeContentCoverCategory] PRIMARY KEY CLUSTERED  ([RefHomeContentCoverCategoryId])
GO
