CREATE TABLE [dbo].[TNeedsAndPrioritiesAnswer]
(
[NeedsAndPrioritiesAnswerId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TNeedsAndPrioritiesAnswer_ConcurrencyId] DEFAULT ((1)),
[CRMContactId] [int] NOT NULL,
[QuestionId] [int] NOT NULL,
[AnswerId] [int] NULL,
[FreeTextAnswer] VARCHAR(MAX) COLLATE Latin1_General_CI_AS NULL,
[AnswerValue] VARCHAR(1000) COLLATE Latin1_General_CI_AS NULL,
[Notes] VARCHAR(MAX)  NULL,
[AnswerOptions] VARCHAR(MAX)  NULL
)
GO

ALTER TABLE [dbo].[TNeedsAndPrioritiesAnswer] ADD CONSTRAINT [PK_TNeedsAndPrioritiesAnswer] PRIMARY KEY NONCLUSTERED  ([NeedsAndPrioritiesAnswerId])
GO

CREATE NONCLUSTERED INDEX IX_TNeedsAndPrioritiesAnswer_CRMContactId ON [dbo].[TNeedsAndPrioritiesAnswer] ([CRMContactId]) 
GO

CREATE NONCLUSTERED INDEX IX_TNeedsAndPrioritiesAnswer_CRMContactId_1 ON [dbo].[TNeedsAndPrioritiesAnswer] ([CRMContactId]) include (NeedsAndPrioritiesAnswerId,ConcurrencyId,questionId,AnswerId,FreeTextAnswer)
GO


