CREATE TABLE [dbo].[TPlanContactAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PlanContactId] [int] NOT NULL,
[SubjectId] [int] NOT NULL,
[SubjectType] [varchar] (50) NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[IsTrusted] [bit] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPlanContactAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL)
GO
ALTER TABLE [dbo].[TPlanContactAudit] ADD CONSTRAINT [PK_TPlanContactAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO