CREATE TABLE [dbo].[TValScheduledPlan]
(
[ValScheduledPlanId] [bigint] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ValuationProviderId] [int] NULL,
[ValScheduleId] [int] NOT NULL,
[PolicyBusinessId] [int] NULL,
[EligibilityMask] [int] NULL,
[EligibilityMaskRequiresUpdating] [bit] NULL,
[Status] [int] NULL,
[Remarks] [varchar] (200) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NULL
)
GO
ALTER TABLE [dbo].[TValScheduledPlan] ADD CONSTRAINT [PK_TValScheduledPlan] PRIMARY KEY NONCLUSTERED  ([ValScheduledPlanId])
GO
CREATE CLUSTERED INDEX CLX_TValScheduledPlan_ValScheduleID ON [dbo].[TValScheduledPlan] ([ValScheduleId])
GO
CREATE NONCLUSTERED INDEX IX_TValScheduledPlan_PolicyBusinessId ON TValScheduledPlan (PolicyBusinessId) INCLUDE ([Status], [ValuationProviderId])
GO