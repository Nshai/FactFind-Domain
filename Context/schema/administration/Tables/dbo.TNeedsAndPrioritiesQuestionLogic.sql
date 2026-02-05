CREATE TABLE [dbo].[TNeedsAndPrioritiesQuestionLogic](
	[NeedsAndPrioritiesQuestionLogicId] [int] IDENTITY(1,1) NOT NULL,
	[NeedsAndPrioritiesQuestionId] [int] NOT NULL,
	[NeedsAndPrioritiesParentQuestionId] [int] NOT NULL,
	[LogicTypeId] [tinyint] NOT NULL,
	[AnswerValue] [varchar](500) NOT NULL,
	[ConcurrencyId] [int] NOT NULL,
	[TenantId] [int] NOT NULL
)
GO

ALTER TABLE [dbo].[TNeedsAndPrioritiesQuestionLogic] ADD CONSTRAINT [PK_TNeedsAndPrioritiesQuestionLogic] PRIMARY KEY CLUSTERED ([NeedsAndPrioritiesQuestionLogicId])
GO

ALTER TABLE [dbo].[TNeedsAndPrioritiesQuestionLogic] ADD CONSTRAINT [FK_TNeedsAndPrioritiesQuestionLogic_NeedsAndPrioritiesQuestion_NeedsAndPrioritiesQuestionId] FOREIGN KEY([NeedsAndPrioritiesQuestionId])
REFERENCES [dbo].[TNeedsAndPrioritiesQuestion] ([NeedsAndPrioritiesQuestionId])
GO

ALTER TABLE [dbo].[TNeedsAndPrioritiesQuestionLogic] ADD CONSTRAINT [FK_TNeedsAndPrioritiesQuestionLogic_NeedsAndPrioritiesQuestion_NeedsAndPrioritiesParentQuestionId] FOREIGN KEY([NeedsAndPrioritiesParentQuestionId])
REFERENCES [dbo].[TNeedsAndPrioritiesQuestion] ([NeedsAndPrioritiesQuestionId])
GO