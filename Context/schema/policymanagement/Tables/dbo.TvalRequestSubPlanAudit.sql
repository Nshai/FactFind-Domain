CREATE TABLE [dbo].[TvalRequestSubPlanAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[ValRequestId] [int] NOT NULL,
[PlanValuationId] [bigint] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[ValRequestSubPlanId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TvalRequestSubPlanAudit] ADD CONSTRAINT [PK_TvalRequestSubPlanAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
