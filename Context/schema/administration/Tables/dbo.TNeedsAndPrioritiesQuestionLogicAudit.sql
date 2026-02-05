CREATE TABLE [dbo].[TNeedsAndPrioritiesQuestionLogicAudit](
	[AuditId] [int] IDENTITY(1,1) NOT NULL,
	[NeedsAndPrioritiesQuestionLogicId] [int] NOT NULL,
	[NeedsAndPrioritiesQuestionId] [int] NOT NULL,
	[NeedsAndPrioritiesParentQuestionId] [int] NOT NULL,
	[LogicTypeId] [tinyint] NOT NULL,
	[AnswerValue] [varchar](500) NOT NULL,
	[ConcurrencyId] [int] NOT NULL,
	[TenantId] [int] NOT NULL,
	[StampAction] [char](1) NOT NULL,
	[StampDateTime] [datetime] NULL,
	[StampUser] [varchar](255) NULL
)
GO

ALTER TABLE [dbo].[TNeedsAndPrioritiesQuestionLogicAudit] ADD CONSTRAINT [PK_TNeedsAndPrioritiesQuestionLogicAudit] PRIMARY KEY CLUSTERED ([AuditId])
GO