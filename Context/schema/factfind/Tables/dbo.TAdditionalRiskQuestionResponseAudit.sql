CREATE TABLE [dbo].[TAdditionalRiskQuestionResponseAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AdditionalRiskQuestionResponseId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[QuestionNumber] [smallint] NOT NULL,
[ResponseId] [smallint] NULL,
[ResponseText] [varchar] (4000) NULL,
[IsRetirement] [bit] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NOT NULL CONSTRAINT [DF_TAdditionalRiskQuestionResponseAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAdditionalRiskQuestionResponseAudit] ADD CONSTRAINT [PK_TAdditionalRiskQuestionResponseAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO