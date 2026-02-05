CREATE TABLE [dbo].[TPlanExceptionDetails]
(
[PlanExceptionDetailsId] [int] NOT NULL IDENTITY(1, 1),
[PlanExceptionQueueId] [int] NOT NULL,
[IsExceeedingSumAssured] [bit] NULL,
[IsExceedingLumpSum] [bit] NULL,
[IsExceeedingRegularContribution] [bit] NULL,
[IsViolatingAgeLimit] [bit] NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[IsPOA] [bit] NULL,
[HasMatchingATR] [bit] NULL,
[HasMatchingAdviceCaseStatus] [bit] NULL,
[HasMatchingVulnerableCustomer] [bit] NULL
)
GO
ALTER TABLE [dbo].[TPlanExceptionDetails] ADD CONSTRAINT [PK_TPlanExceptionDetails] PRIMARY KEY CLUSTERED  ([PlanExceptionDetailsId])
GO
ALTER TABLE [dbo].[TPlanExceptionDetails] ADD CONSTRAINT [FK_TPlanExceptionDetails_TPlanExceptionQueue] FOREIGN KEY ([PlanExceptionQueueId]) REFERENCES [dbo].[TPlanExceptionQueue] ([PlanExceptionQueueId])
GO
