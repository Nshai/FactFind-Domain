CREATE TABLE [dbo].[TNeedsAndPrioritiesQuestionTagAudit](
	[AuditId] [int] IDENTITY(1,1) NOT NULL,
	[NeedsAndPrioritiesQuestionTagId] [int] NOT NULL,
	[NeedsAndPrioritiesQuestionId] [int] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[TenantId] [int] NOT NULL,
	[StampAction] [char](1) NOT NULL,
	[StampDateTime] [datetime] NULL CONSTRAINT [DF_TNeedsAndPrioritiesQuestionTagAudit_StampDateTime] DEFAULT (getdate()),
	[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
)
GO

ALTER TABLE [dbo].[TNeedsAndPrioritiesQuestionTagAudit] ADD CONSTRAINT [PK_TNeedsAndPrioritiesQuestionTagAudit] PRIMARY KEY CLUSTERED ([AuditId])
GO