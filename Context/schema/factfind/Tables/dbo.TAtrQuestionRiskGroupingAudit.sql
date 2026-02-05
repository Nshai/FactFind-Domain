CREATE TABLE [dbo].[TAtrQuestionRiskGroupingAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NULL,
[RiskGroupingId] [int] NOT NULL,
[AtrQuestionGuid] [uniqueidentifier] NOT NULL,
[AtrTemplateGuid] [uniqueidentifier] NOT NULL,
[AtrQuestionRiskGroupingId] [int] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAtrQuestionRiskGroupingAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAtrQuestionRiskGroupingAudit] ADD CONSTRAINT [PK_TAtrQuestionRiskGroupingAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
