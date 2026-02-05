CREATE TABLE [dbo].[TValRequestSubPlan]
(
[ValRequestSubPlanId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[ValRequestId] [int] NOT NULL,
[PlanValuationId] [bigint] NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TValRequestSubPlan] ADD CONSTRAINT [PK_TValRequestSubPlan] PRIMARY KEY CLUSTERED  ([ValRequestSubPlanId])
GO
create index IX_INCL_TValRequestSubPlan_PlanValuationId on TValRequestSubPlan (PlanValuationId) include (ValRequestSubPlanId, ValRequestId, PolicyBusinessId, ConcurrencyId)
GO
CREATE NONCLUSTERED INDEX IX_TValRequestSubPlan_PolicyBusinessId ON [dbo].[TValRequestSubPlan] ([PolicyBusinessId]) INCLUDE ([ValRequestId]) 
GO
