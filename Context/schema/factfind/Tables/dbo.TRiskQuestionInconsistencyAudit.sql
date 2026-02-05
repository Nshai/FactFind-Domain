CREATE TABLE [dbo].[TRiskQuestionInconsistencyAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RiskQuestionInconsistencyId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[Message] [varchar] (4000) NULL,
[IsRetirement] [bit] NOT NULL,
[IsAdviserNote] [bit] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NOT NULL CONSTRAINT [DF_TRiskQuestionInconsistencyAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRiskQuestionInconsistencyAudit] ADD CONSTRAINT [PK_TRiskQuestionInconsistencyAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO