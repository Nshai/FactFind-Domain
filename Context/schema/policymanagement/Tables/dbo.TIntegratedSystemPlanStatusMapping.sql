CREATE TABLE [dbo].[TIntegratedSystemPlanStatusMapping]
(
[IntegratedSystemPlanStatusMappingId] [int] NOT NULL IDENTITY(1, 1),
[ApplicationLinkId] [int] NOT NULL,
[ChangePlanStatusToInForce] [bit] NOT NULL CONSTRAINT [DF_TIntegratedSystemPlanStatusMapping_ChangePlanStatusToInForce] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIntegratedSystemPlanStatusMapping_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TIntegratedSystemPlanStatusMapping] ADD CONSTRAINT [PK_TIntegratedSystemPlanStatusMapping] PRIMARY KEY NONCLUSTERED  ([IntegratedSystemPlanStatusMappingId])
GO