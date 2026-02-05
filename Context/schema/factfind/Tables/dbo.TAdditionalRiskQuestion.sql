CREATE TABLE [dbo].[TAdditionalRiskQuestion]
(
[AdditionalRiskQuestionId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NOT NULL,
[QuestionNumber] [smallint] NOT NULL,
[QuestionText] [varchar] (1000) NOT NULL
)
GO
ALTER TABLE [dbo].[TAdditionalRiskQuestion] ADD CONSTRAINT [PK_TAdditionalRiskQuestion] PRIMARY KEY NONCLUSTERED ([AdditionalRiskQuestionId])
GO
CREATE NONCLUSTERED INDEX [IX_TAdditionalRiskQuestion_TenantId] ON [dbo].[TAdditionalRiskQuestion] ([TenantId])
GO