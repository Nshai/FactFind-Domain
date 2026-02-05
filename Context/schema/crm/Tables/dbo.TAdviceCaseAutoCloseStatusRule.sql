CREATE TABLE [dbo].[TAdviceCaseAutoCloseStatusRule]
(
[AdviceCaseAutoCloseStatusRuleId] [int] NOT NULL IDENTITY(1, 1),
[NumberOfDays] [int] NULL,
[AdviceCaseAutoCloseRule] [int] NOT NULL CONSTRAINT [DF_TAdviceCaseAutoCloseStatusRule_AdviceCaseAutoCloseRule] DEFAULT ((0)),
[IndigoClientId] [int] NOT NULL,
[HasReopenRule] [bit] NULL CONSTRAINT [DF__TAdviceCa__HasRe__7B47DA60] DEFAULT ((0)),
[ReopenNumberOfDays] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviceCaseAutoCloseStatusRule_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAdviceCaseAutoCloseStatusRule] ADD CONSTRAINT [PK_TAdviceCaseAutoCloseStatusRule] PRIMARY KEY CLUSTERED  ([AdviceCaseAutoCloseStatusRuleId])
GO
