CREATE TABLE [dbo].[TNeedsAndPrioritiesAnswerAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1)  ,
[NeedsAndPrioritiesAnswerId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[QuestionId] [int] NOT NULL,
[AnswerId] [int] NULL,
[StampAction] [char] (1)  NOT NULL,
[StampDateTime] [datetime] NOT NULL CONSTRAINT [DF_TNeedsAndPrioritiesAnswerAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255)  NOT NULL,
[FreeTextAnswer] VARCHAR(MAX)  NULL,
[AnswerValue] VARCHAR(1000)  NULL,
[Notes] VARCHAR(MAX)  NULL,
[AnswerOptions] VARCHAR(MAX)  NULL
)
GO

ALTER TABLE [dbo].[TNeedsAndPrioritiesAnswerAudit] ADD CONSTRAINT [PK_TNeedsAndPrioritiesAnswerAudit] PRIMARY KEY NONCLUSTERED  ([AuditId], [StampDateTime])
GO

CREATE CLUSTERED INDEX [CLX_TNeedsAndPrioritiesAnswerAudit] ON [dbo].[TNeedsAndPrioritiesAnswerAudit] ([NeedsAndPrioritiesAnswerId], [StampDateTime])
GO
