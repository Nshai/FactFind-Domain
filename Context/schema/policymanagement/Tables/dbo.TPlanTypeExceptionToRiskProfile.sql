--drop TABLE [dbo].[TPlanTypeExceptionToRiskProfile]
CREATE TABLE [dbo].[TPlanTypeExceptionToRiskProfile]
(
[PlanTypeExceptionToRiskProfileId] [int] NOT NULL IDENTITY(1, 1),
[PlanTypeExceptionId] [int] NOT NULL,
[RiskProfileGuid] [uniqueidentifier] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TPlanTypeExceptionToRiskProfile_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPlanTypeExceptionToRiskProfile] ADD CONSTRAINT [PK_TPlanTypeExceptionToRiskProfile] PRIMARY KEY CLUSTERED  ([PlanTypeExceptionToRiskProfileId])
GO
CREATE NONCLUSTERED INDEX [Index_PlanTypeExceptionId] ON [dbo].[TPlanTypeExceptionToRiskProfile] ([PlanTypeExceptionId])
GO
ALTER TABLE [dbo].[TPlanTypeExceptionToRiskProfile] ADD CONSTRAINT [FK_TPlanTypeExceptionToRiskProfile_TPlanTypeException] FOREIGN KEY ([PlanTypeExceptionId]) REFERENCES [dbo].[TPlanTypeException] ([PlanTypeExceptionId])
GO
ALTER TABLE [dbo].[TPlanTypeExceptionToRiskProfile] ADD CONSTRAINT [FK_TPlanTypeExceptionToRiskProfile_TRiskProfileCombined] FOREIGN KEY ([RiskProfileGuid]) REFERENCES [dbo].[TRiskProfileCombined] ([Guid])
GO
