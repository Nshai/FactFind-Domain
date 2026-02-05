CREATE TABLE [dbo].[TNeedsAndPrioritiesQuestionAnswer]
(
[NeedsAndPrioritiesQuestionAnswerId] [int] NOT NULL IDENTITY(1, 1),
[NeedsAndPrioritiesQuestionId] [int] NOT NULL,
[Answer] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Ordinal] [int] NOT NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TFactFindQuestionAnswer_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFactFindQuestionsAnswer_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TNeedsAndPrioritiesQuestionAnswer] ADD CONSTRAINT [PK_TFactFindQuestionsAnswer] PRIMARY KEY CLUSTERED  ([NeedsAndPrioritiesQuestionAnswerId])
GO
