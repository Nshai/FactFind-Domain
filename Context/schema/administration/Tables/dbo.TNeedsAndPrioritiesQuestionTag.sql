CREATE TABLE [dbo].[TNeedsAndPrioritiesQuestionTag](
	[NeedsAndPrioritiesQuestionTagId] [int] IDENTITY(1,1) NOT NULL,
	[NeedsAndPrioritiesQuestionId] [int] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[TenantId] [int] NOT NULL
)
GO

ALTER TABLE [dbo].[TNeedsAndPrioritiesQuestionTag] ADD CONSTRAINT [PK_TNeedsAndPrioritiesQuestionTag] PRIMARY KEY CLUSTERED ([NeedsAndPrioritiesQuestionTagId])
GO

ALTER TABLE [dbo].[TNeedsAndPrioritiesQuestionTag] ADD CONSTRAINT [FK_TNeedsAndPrioritiesQuestionTag_NeedsAndPrioritiesQuestion_NeedsAndPrioritiesQuestionId] FOREIGN KEY([NeedsAndPrioritiesQuestionId])
REFERENCES [dbo].[TNeedsAndPrioritiesQuestion] ([NeedsAndPrioritiesQuestionId])
GO

CREATE NONCLUSTERED INDEX [IX_TNeedsAndPrioritiesQuestionTag_Name] ON [dbo].[TNeedsAndPrioritiesQuestionTag] ([Name])
GO