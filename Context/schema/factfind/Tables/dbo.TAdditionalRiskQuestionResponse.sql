CREATE TABLE [dbo].[TAdditionalRiskQuestionResponse]
(
[AdditionalRiskQuestionResponseId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[QuestionNumber] [smallint] NOT NULL,
[ResponseId] [smallint] NULL,
[ResponseText] [varchar] (4000) NULL,
[IsRetirement] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[TAdditionalRiskQuestionResponse] ADD CONSTRAINT [PK_TAdditionalRiskQuestionResponse] PRIMARY KEY NONCLUSTERED ([AdditionalRiskQuestionResponseId])
GO
