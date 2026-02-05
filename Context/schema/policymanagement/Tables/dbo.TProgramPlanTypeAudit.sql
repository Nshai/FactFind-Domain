CREATE TABLE [dbo].[TProgramPlanTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ProgramPlanTypeId] [int] NOT NULL,
[ProgramId] [int] NOT NULL,
[PlanTypeId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TProgramPlanTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TProgramPlanTypeAudit] ADD CONSTRAINT [PK_TProgramPlanTypeAudit_AuditId] PRIMARY KEY CLUSTERED ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TProgramPlanTypeAudit] ON [dbo].[TProgramPlanTypeAudit] ([PlanTypeId])
GO