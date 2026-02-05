CREATE TABLE [dbo].[TEvalueResultAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[EvalueLogId] [int] NOT NULL,
[AxisImageGuid] [uniqueidentifier] NOT NULL,
[RefEvalueModellingTypeId] [int] NULL,
[ParentEvalueLogId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEvalueResultAudit_ConcurrencyId] DEFAULT ((1)),
[EvalueResultId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TEvalueResultAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEvalueResultAudit] ADD CONSTRAINT [PK_TEvalueResultAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TEvalueResultAudit_EvalueResultId_ConcurrencyId] ON [dbo].[TEvalueResultAudit] ([EvalueResultId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
