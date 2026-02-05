CREATE TABLE [dbo].[TExtraRiskQuestionAnswerAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefRiskQuestionId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[Answer] [bit] NULL,
[ConcurrencyId] [int] NOT NULL,
[ExtraRiskQuestionAnswerId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TExtraRiskQuestionAnswerAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Comment] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TExtraRiskQuestionAnswerAudit] ADD CONSTRAINT [PK_TExtraRiskQuestionAnswerAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
