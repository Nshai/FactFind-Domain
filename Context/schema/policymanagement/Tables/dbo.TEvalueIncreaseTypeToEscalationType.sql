CREATE TABLE [dbo].[TEvalueIncreaseTypeToEscalationType]
(
[EvalueIncreaseTypeToEscalationTypeId] [int] NOT NULL IDENTITY(1, 1),
[RefEvalueIncreaseTypeId] [int] NOT NULL,
[RefEscalationTypeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEvalueIncreaseTypeToEscalationType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TEvalueIncreaseTypeToEscalationType] ADD CONSTRAINT [PK_TEvalueIncreaseTypeToEscalationType] PRIMARY KEY CLUSTERED  ([EvalueIncreaseTypeToEscalationTypeId])
GO
