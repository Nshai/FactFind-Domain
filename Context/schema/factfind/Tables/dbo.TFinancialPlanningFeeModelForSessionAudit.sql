CREATE TABLE [dbo].[TFinancialPlanningFeeModelForSessionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[FeeModelId] [int] NULL,
[InitialFeeModelTemplateId] [int] NULL,
[InitialAdviseFeeChargingDetailsId] [int] NULL,
[DiscountId] [int] NULL,
[OngoingFeeModelTemplateId] [int] NULL,
[OngoingAdviseFeeChargingDetailsId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningFeeModelForSessionAudit_ConcurrencyId] DEFAULT ((0)),
[FinancialPlanningFeeModelForSessionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFinancialPlanningFeeModelForSessionAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFinancialPlanningFeeModelForSessionAudit] ADD CONSTRAINT [PK_TFinancialPlanningFeeModelForSessionAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
