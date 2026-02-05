CREATE TABLE [dbo].[TAtrAnswerCategory]
(
[AtrAnswerCategoryId] [int] NOT NULL IDENTITY(1, 1),
[AtrCategoryQuestionId] [int] NOT NULL,
[AtrAnswerGuid] [uniqueidentifier] NOT NULL,
[Ordinal] [tinyint] NOT NULL,
[Weighting] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrAnswerCategory_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAtrAnswerCategory] ADD CONSTRAINT [PK_TAtrAnswerCategory] PRIMARY KEY NONCLUSTERED  ([AtrAnswerCategoryId])
GO
CREATE NONCLUSTERED INDEX IX_TAtrAnswerCategory_AtrCategoryQuestionId ON [dbo].[TAtrAnswerCategory] ([AtrCategoryQuestionId]) INCLUDE ([AtrAnswerGuid],[Ordinal],[Weighting])
GO