CREATE TABLE [dbo].[TEvalueResult]
(
[EvalueResultId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[EvalueLogId] [int] NOT NULL,
[AxisImageGuid] [uniqueidentifier] NOT NULL,
[RefEvalueModellingTypeId] [int] NOT NULL,
[ParentEvalueLogId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEvalueResult_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TEvalueResult] ADD CONSTRAINT [PK_TEvalueResult] PRIMARY KEY NONCLUSTERED  ([EvalueResultId])
GO
ALTER TABLE [dbo].[TEvalueResult] ADD  CONSTRAINT [DF_TEvalueResult_RefEvalueModellingTypeId]  DEFAULT ((1)) FOR [RefEvalueModellingTypeId]
GO
