CREATE TABLE [dbo].[TRefGoalCategory]
(
[RefGoalCategoryId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefGoalCategory_ConcurrencyId] DEFAULT ((1)),
[Ordinal] [int] NULL
)
GO
ALTER TABLE [dbo].[TRefGoalCategory] ADD CONSTRAINT [PK_TRefGoalsCategory] PRIMARY KEY CLUSTERED  ([RefGoalCategoryId])
GO
