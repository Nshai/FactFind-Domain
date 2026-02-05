CREATE TABLE [dbo].[TActionPlanFeeModelAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ActionPlanId] [int] NOT NULL,
[FeeModelId] [int] NULL,
[InitialFeeModelTemplateId] [int] NULL,
[InitialAdviseFeeChargingDetailsId] [int] NULL,
[DiscountId] [int] NULL,
[OngoingFeeModelTemplateId] [int] NULL,
[OngoingAdviseFeeChargingDetailsId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TActionPlanFeeModelAudit_ConcurrencyId] DEFAULT ((0)),
[ActionPlanFeeModelId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TActionPlanFeeModelAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TActionPlanFeeModelAudit] ADD CONSTRAINT [PK_TActionPlanFeeModelAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
