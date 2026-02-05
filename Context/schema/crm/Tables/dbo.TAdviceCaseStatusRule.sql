CREATE TABLE [dbo].[TAdviceCaseStatusRule]
(
[AdviceCaseStatusRuleId] [int] NOT NULL IDENTITY(1, 1),
[RuleDescriptor] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ActionDescriptor] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TAdviceCaseStatusRule_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviceCaseStatusRule_ConcurrencyId] DEFAULT ((1))
)
GO
