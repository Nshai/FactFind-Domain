CREATE TABLE [dbo].[TPlanTypeExceptionToPlanTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PlanTypeExceptionToPlanTypeId] [int] NULL,
[PlanTypeExceptionId] [int] NULL,
[RefPlanType2ProdSubTypeId] [int] NULL,
[TenantId] [int] NULL,
[ConcurrencyId] [int] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPlanTypeExceptionToPlanTypeAudit] ADD CONSTRAINT [PK_PlanTypeExceptionToPlanTypeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
