CREATE TABLE [dbo].[TNeedsAndPrioritiesQuestionAttributeAudit](
	[AuditId] [int] IDENTITY(1,1) NOT NULL,
	[NeedsAndPrioritiesQuestionAttributeId] [int] NOT NULL,
	[NeedsAndPrioritiesQuestionId] [int] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Value] [nvarchar](255) NOT NULL,
	[ConcurrencyId] [int] NOT NULL,
	[TenantId] [int] NOT NULL,
	[StampAction] [char](1) NOT NULL,
	[StampDateTime] [datetime] NULL,
	[StampUser] [varchar](255) NULL
)
GO

ALTER TABLE [dbo].[TNeedsAndPrioritiesQuestionAttributeAudit] ADD CONSTRAINT [PK_TNeedsAndPrioritiesQuestionAttributeAudit] PRIMARY KEY CLUSTERED ([AuditId])
GO