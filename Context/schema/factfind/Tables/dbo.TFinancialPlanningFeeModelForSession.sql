CREATE TABLE [dbo].[TFinancialPlanningFeeModelForSession]
(
[FinancialPlanningFeeModelForSessionId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[FeeModelId] [int] NULL,
[InitialFeeModelTemplateId] [int] NULL,
[InitialAdviseFeeChargingDetailsId] [int] NULL,
[DiscountId] [int] NULL,
[OngoingFeeModelTemplateId] [int] NULL,
[OngoingAdviseFeeChargingDetailsId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningFeeModelForSession_ConcurrencyId] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TFinancialPlanningFeeModelForSession] ADD CONSTRAINT [PK_TFinancialPlanningFeeModelForSession] PRIMARY KEY CLUSTERED  ([FinancialPlanningFeeModelForSessionId])
GO
