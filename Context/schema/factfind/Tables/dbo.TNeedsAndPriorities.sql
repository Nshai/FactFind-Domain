CREATE TABLE [dbo].[TNeedsAndPriorities]
(
	[NeedsAndPrioritiesId] [int] IDENTITY(1,1) NOT NULL,
	[ConcurrencyId] [int] NOT NULL,
	[FactFindId] [int] NOT NULL,
	[ClientsHaveTheSameAnswers] [bit] NOT NULL,
	[CategoryId] [int] NOT NULL,
	[TenantId] [int] NOT NULL	
)
GO
ALTER TABLE [dbo].[TNeedsAndPriorities] ADD CONSTRAINT [PK_TNeedsAndPriorities] PRIMARY KEY NONCLUSTERED  ([NeedsAndPrioritiesId])
GO
CREATE CLUSTERED INDEX CIX_TNeedsAndPriorities_FactFindId_CategoryId ON [dbo].[TNeedsAndPriorities] ([FactFindId], [CategoryId] ASC) 
GO