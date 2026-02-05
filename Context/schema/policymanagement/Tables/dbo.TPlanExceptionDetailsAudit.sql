CREATE TABLE [dbo].[TPlanExceptionDetailsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PlanExceptionDetailsId] [int] NOT NULL,
[PlanExceptionQueueId] [int] NOT NULL,
[IsExceeedingSumAssured] [bit] NULL,
[IsExceedingLumpSum] [bit] NULL,
[IsExceeedingRegularContribution] [bit] NULL,
[IsViolatingAgeLimit] [bit] NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsPOA] [bit] NULL,
[HasMatchingATR] [bit] NULL,
[HasMatchingAdviceCaseStatus] [bit] NULL,
[HasMatchingVulnerableCustomer] [bit] NULL
)
GO
ALTER TABLE [dbo].[TPlanExceptionDetailsAudit] ADD CONSTRAINT [PK_TPlanExceptionDetailsAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
