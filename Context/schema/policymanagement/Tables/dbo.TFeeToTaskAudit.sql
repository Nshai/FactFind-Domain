CREATE TABLE [dbo].[TFeeToTaskAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FeeId] [int] NOT NULL,
[TaskId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NULL,
[FeeToTaskId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFeeToTaskAudit] ADD CONSTRAINT [PK_TFeeToTaskAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
