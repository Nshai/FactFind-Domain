CREATE TABLE [dbo].[TEvalueAgreementAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[EvalueLogId] [int] NOT NULL,
[GoalType] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[GoalId] [int] NOT NULL,
[ScenarioId] [int] NOT NULL,
[AgreementId] [int] NOT NULL,
[AgreementXml] [xml] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEvalueAgreementAudit_ConcurrencyId] DEFAULT ((0)),
[EvalueAgreementId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TEvalueAgreementAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEvalueAgreementAudit] ADD CONSTRAINT [PK_TEvalueAgreementAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TEvalueAgreementAudit_EvalueAgreementId_ConcurrencyId] ON [dbo].[TEvalueAgreementAudit] ([EvalueAgreementId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
