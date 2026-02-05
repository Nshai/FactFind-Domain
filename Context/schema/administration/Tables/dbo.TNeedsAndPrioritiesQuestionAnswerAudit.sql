CREATE TABLE [dbo].[TNeedsAndPrioritiesQuestionAnswerAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[NeedsAndPrioritiesQuestionId] [int] NOT NULL,
[Answer] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Ordinal] [int] NOT NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TFactFindQuestionAnswerAudit_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFactFindQuestionsAnswerAudit_ConcurrencyId] DEFAULT ((1)),
[NeedsAndPrioritiesQuestionAnswerId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFactFindQuestionsAnswerAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TNeedsAndPrioritiesQuestionAnswerAudit] ADD CONSTRAINT [PK_TFactFindQuestionsAnswerAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
