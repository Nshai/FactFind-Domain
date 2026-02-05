--drop TABLE [dbo].[TPlanTypeExceptionToRiskProfileAudit]
CREATE TABLE [dbo].[TPlanTypeExceptionToRiskProfileAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PlanTypeExceptionToRiskProfileId] [int] NULL,
[PlanTypeExceptionId] [int] NULL,
[RiskProfileGuid] [uniqueidentifier] NULL,
[TenantId] [int] NULL,
[ConcurrencyId] [int] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPlanTypeExceptionToRiskProfileAudit] ADD CONSTRAINT [PK_PlanTypeExceptionToRiskProfileAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
