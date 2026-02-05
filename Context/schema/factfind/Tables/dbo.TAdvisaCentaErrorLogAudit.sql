CREATE TABLE [dbo].[TAdvisaCentaErrorLogAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningSessionId] [int] NULL,
[IoMessage] [varchar] (8000) COLLATE Latin1_General_CI_AS NULL,
[Exception] [xml] NULL,
[CreatedDate] [datetime] NOT NULL,
[UserId] [int] NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[AdvisaCentaErrorLogId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAdvisaCentaErrorLogAudit] ADD CONSTRAINT [PK_TAdvisaCentaErrorLogAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
