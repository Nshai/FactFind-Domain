CREATE TABLE [dbo].[TEvalueAgreement]
(
[EvalueAgreementId] [int] NOT NULL IDENTITY(1, 1),
[EvalueLogId] [int] NOT NULL,
[GoalType] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[GoalId] [int] NOT NULL,
[ScenarioId] [int] NOT NULL,
[AgreementId] [int] NOT NULL,
[AgreementXml] [xml] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEvalueAgreement_ConcurrencyId] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TEvalueAgreement] ADD CONSTRAINT [PK_TEvalueAgreement] PRIMARY KEY NONCLUSTERED  ([EvalueAgreementId])
GO
