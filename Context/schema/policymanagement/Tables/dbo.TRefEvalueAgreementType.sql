CREATE TABLE [dbo].[TRefEvalueAgreementType]
(
[RefEvalueAgreementTypeId] [int] NOT NULL IDENTITY(1, 1),
[EvalueAgreementClass] [varchar] (250) COLLATE Latin1_General_CI_AS NULL,
[EvalueAgreementTypeName] [varchar] (250) COLLATE Latin1_General_CI_AS NULL,
[EvalueAgreementProductName] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NULL
)
GO
ALTER TABLE [dbo].[TRefEvalueAgreementType] ADD CONSTRAINT [PK_TRefEvalueAgreementType] PRIMARY KEY CLUSTERED  ([RefEvalueAgreementTypeId])
GO
