CREATE TABLE [dbo].[TFPDefaultCharge]
(
[FPDefaultChargeId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NOT NULL,
[InitialChargeLumpsum] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_TFPDefaultCharge_InitialChargeLumpsum] DEFAULT ((0)),
[InitialChargeContribution] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_TFPDefaultCharge_InitialChargeContribution] DEFAULT ((0)),
[InitialPeriodMonths] [int] NOT NULL CONSTRAINT [DF_TFPDefaultCharge_InitialPeriodMonths] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TFPDefaultCharge] ADD CONSTRAINT [PK_TFPDefaultCharge] PRIMARY KEY CLUSTERED  ([FPDefaultChargeId])
GO
