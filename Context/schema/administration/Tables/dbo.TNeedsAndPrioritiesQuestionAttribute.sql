CREATE TABLE [dbo].[TNeedsAndPrioritiesQuestionAttribute](
	[NeedsAndPrioritiesQuestionAttributeId] [int] IDENTITY(1,1) NOT NULL,
	[NeedsAndPrioritiesQuestionId] [int] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Value] [nvarchar](255) NOT NULL,
	[ConcurrencyId] [int] NOT NULL,
	[TenantId] [int] NOT NULL
)
GO

ALTER TABLE [dbo].[TNeedsAndPrioritiesQuestionAttribute] ADD CONSTRAINT [PK_TNeedsAndPrioritiesQuestionAttribute] PRIMARY KEY CLUSTERED ([NeedsAndPrioritiesQuestionAttributeId])
GO

ALTER TABLE [dbo].[TNeedsAndPrioritiesQuestionAttribute] ADD CONSTRAINT [FK_TNeedsAndPrioritiesQuestionAttribute_NeedsAndPrioritiesQuestion_NeedsAndPrioritiesQuestionId] FOREIGN KEY([NeedsAndPrioritiesQuestionId])
REFERENCES [dbo].[TNeedsAndPrioritiesQuestion] ([NeedsAndPrioritiesQuestionId])
GO
