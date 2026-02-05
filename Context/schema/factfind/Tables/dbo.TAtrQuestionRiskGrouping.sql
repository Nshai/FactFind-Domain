CREATE TABLE [dbo].[TAtrQuestionRiskGrouping]
(
[AtrQuestionRiskGroupingId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrQuestionRiskGrouping_ConcurrencyId] DEFAULT ((1)),
[RiskGroupingId] [int] NOT NULL,
[AtrQuestionGuid] [uniqueidentifier] NOT NULL,
[AtrTemplateGuid] [uniqueidentifier] NOT NULL
)
GO
ALTER TABLE [dbo].[TAtrQuestionRiskGrouping] ADD CONSTRAINT [PK_TAtrQuestionRiskGrouping] PRIMARY KEY NONCLUSTERED  ([AtrQuestionRiskGroupingId])
GO
