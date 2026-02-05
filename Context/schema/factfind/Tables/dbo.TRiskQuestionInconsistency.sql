CREATE TABLE [dbo].[TRiskQuestionInconsistency]
(
[RiskQuestionInconsistencyId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[Message] [varchar] (4000) NULL,
[IsRetirement] [bit] NOT NULL,
[IsAdviserNote] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[TRiskQuestionInconsistency] ADD CONSTRAINT [PK_TRiskQuestionInconsistency] PRIMARY KEY NONCLUSTERED ([RiskQuestionInconsistencyId])
GO
