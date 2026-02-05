CREATE TABLE [dbo].[TPlanTypeExceptionToPlanType]
(
[PlanTypeExceptionToPlanTypeId] [int] NOT NULL IDENTITY(1, 1),
[PlanTypeExceptionId] [int] NOT NULL,
[RefPlanType2ProdSubTypeId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TPlanTypeExceptionToPlanType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPlanTypeExceptionToPlanType] ADD CONSTRAINT [PK_TPlanTypeExceptionToPlanType] PRIMARY KEY CLUSTERED  ([PlanTypeExceptionToPlanTypeId])
GO
CREATE NONCLUSTERED INDEX [Index_PlanTypeExceptionId] ON [dbo].[TPlanTypeExceptionToPlanType] ([PlanTypeExceptionId])
GO
ALTER TABLE [dbo].[TPlanTypeExceptionToPlanType] ADD CONSTRAINT [FK_TPlanTypeExceptionToPlanType_TPlanTypeException] FOREIGN KEY ([PlanTypeExceptionId]) REFERENCES [dbo].[TPlanTypeException] ([PlanTypeExceptionId])
GO
ALTER TABLE [dbo].[TPlanTypeExceptionToPlanType] ADD CONSTRAINT [FK_TPlanTypeExceptionToPlanType_TRefPlanType2ProdSubType] FOREIGN KEY ([RefPlanType2ProdSubTypeId]) REFERENCES [dbo].[TRefPlanType2ProdSubType] ([RefPlanType2ProdSubTypeId])
GO
