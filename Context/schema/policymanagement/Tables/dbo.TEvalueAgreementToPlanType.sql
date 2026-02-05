CREATE TABLE [dbo].[TEvalueAgreementToPlanType]
(
[EvalueAgreementToPlanTypeId] [int] NOT NULL IDENTITY(1, 1),
[RefEvalueAgreementTypeId] [int] NOT NULL,
[RefPlanType2ProdSubTypeId] [int] NOT NULL,
[ConcurrencyId] [int] NULL,
[RepopEvalueAgreementTypeId] [int] NULL
)
GO
ALTER TABLE [dbo].[TEvalueAgreementToPlanType] ADD CONSTRAINT [PK_TEvalueToPlanType] PRIMARY KEY CLUSTERED  ([EvalueAgreementToPlanTypeId])
GO
