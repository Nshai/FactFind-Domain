CREATE TABLE [dbo].[TAdviceCaseStatusTransitionRule]
(
[AdviceCaseStatusTransitionRuleId] [int] NOT NULL IDENTITY(1, 1),
[AdviceCaseStatusChangeId] [int] NOT NULL,
[AdviceCaseStatusRuleId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviceCaseStatusTransitionRule_ConcurrencyId] DEFAULT ((1))
)
GO
