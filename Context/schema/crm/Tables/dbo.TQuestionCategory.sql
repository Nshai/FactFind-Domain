CREATE TABLE [dbo].[TQuestionCategory]
(
[QuestionCategoryId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ArchiveFg] [bit] NOT NULL CONSTRAINT [DF_TQuestionCategory_ArchiveFg] DEFAULT ((0)),
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQuestionC_ConcurrencyId_1__61] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TQuestionCategory] ADD CONSTRAINT [PK_TQuestionCategory_2__61] PRIMARY KEY NONCLUSTERED  ([QuestionCategoryId]) WITH (FILLFACTOR=80)
GO
