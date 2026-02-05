CREATE TABLE [dbo].[TEvalueResultDetail]
(
[EvalueResultDetailId] [int] NOT NULL IDENTITY(1, 1),
[EvalueResultId] [int] NOT NULL,
[FinancialPlanningScenarioId] [int] NOT NULL,
[EvalueXML] [xml] NOT NULL,
[PODGuid] [uniqueidentifier] NOT NULL,
[FinalPod] [bit] NOT NULL CONSTRAINT [DF_TEvalueResultDetail_FinalPod] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEvalueResultDetail_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TEvalueResultDetail] ADD CONSTRAINT [PK_TEvalueResultDetail] PRIMARY KEY NONCLUSTERED  ([EvalueResultDetailId])
GO
