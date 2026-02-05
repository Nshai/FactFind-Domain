CREATE TABLE [dbo].[TActionPlanFeeModel]
(
[ActionPlanFeeModelId] [int] NOT NULL IDENTITY(1, 1),
[ActionPlanId] [int] NOT NULL,
[FeeModelId] [int] NULL,
[InitialFeeModelTemplateId] [int] NULL,
[InitialAdviseFeeChargingDetailsId] [int] NULL,
[DiscountId] [int] NULL,
[OngoingFeeModelTemplateId] [int] NULL,
[OngoingAdviseFeeChargingDetailsId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TActionPlanFeeModel_ConcurrencyId] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TActionPlanFeeModel] ADD CONSTRAINT [PK_TActionPlanFeeModel] PRIMARY KEY CLUSTERED  ([ActionPlanFeeModelId])
GO
