CREATE TABLE [dbo].[TEvalueResultDetailAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[EvalueResultId] [int] NOT NULL,
[FinancialPlanningScenarioId] [int] NOT NULL,
[EvalueXML] [xml] NOT NULL,
[PODGuid] [uniqueidentifier] NOT NULL,
[FinalPod] [bit] NOT NULL CONSTRAINT [DF_TEvalueResultDetailAudit_FinalPod] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEvalueResultDetailAudit_ConcurrencyId] DEFAULT ((1)),
[EvalueResultDetailId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TEvalueResultDetailAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEvalueResultDetailAudit] ADD CONSTRAINT [PK_TEvalueResultDetailAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TEvalueResultDetailAudit_EvalueResultDetailId_ConcurrencyId] ON [dbo].[TEvalueResultDetailAudit] ([EvalueResultDetailId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
