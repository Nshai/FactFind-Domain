CREATE TABLE [dbo].[TAdditionalRiskQuestionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AdditionalRiskQuestionId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[QuestionNumber] [smallint] NOT NULL,
[QuestionText] [varchar] (1000) NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NOT NULL CONSTRAINT [DF_TAdditionalRiskQuestionAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAdditionalRiskQuestionAudit] ADD CONSTRAINT [PK_TAdditionalRiskQuestionAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO