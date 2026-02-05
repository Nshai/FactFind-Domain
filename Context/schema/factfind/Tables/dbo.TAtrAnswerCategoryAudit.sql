CREATE TABLE [dbo].[TAtrAnswerCategoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AtrAnswerCategoryId] [int] NOT NULL,
[AtrCategoryQuestionId] [int] NOT NULL,
[AtrAnswerGuid] [uniqueidentifier] NOT NULL,
[Ordinal] [tinyint] NOT NULL,
[Weighting] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrAnswerCategoryAudit_ConcurrencyId] DEFAULT ((1)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAtrAnswerCategoryAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAtrAnswerCategoryAudit] ADD CONSTRAINT [PK_TAtrAnswerCategoryAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
