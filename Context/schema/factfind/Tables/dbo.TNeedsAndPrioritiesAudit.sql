CREATE TABLE [dbo].[TNeedsAndPrioritiesAudit]
(
	[AuditId] [int] IDENTITY(1,1) NOT NULL,
	[NeedsAndPrioritiesId] [int] NOT NULL,
	[ConcurrencyId] [int] NOT NULL,
	[FactFindId] [int] NOT NULL,
	[CategoryId] [int] NOT NULL,
	[TenantId] [int] NOT NULL,
	[ClientsHaveTheSameAnswers] [bit] NULL,
	[StampAction] [char](1) NOT NULL,
	[StampDateTime] [datetime] NOT NULL,
	[StampUser] [varchar](255) NOT NULL
)
GO
ALTER TABLE [dbo].[TNeedsAndPrioritiesAudit] ADD CONSTRAINT [PK_TNeedsAndPrioritiesAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO