CREATE TABLE [dbo].[TPolicyBusinessTotalPlanValuationTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NOT NULL,
[RefTotalPlanValuationTypeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPolicyBusinessTotalPlanValuationTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[PolicyBusinessTotalPlanValuationTypeId] [int] NULL,
PlanMigrationRef varchar(255)
)
GO
ALTER TABLE [dbo].[TPolicyBusinessTotalPlanValuationTypeAudit] ADD CONSTRAINT [PK_TPolicyBusinessTotalPlanValuationTypeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
