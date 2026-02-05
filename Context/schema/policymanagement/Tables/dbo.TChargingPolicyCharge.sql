CREATE TABLE [dbo].[TChargingPolicyCharge]
(
[ChargingPolicyChargeId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[ChargeDate] [datetime] NOT NULL,
[ChargeType] [int] NOT NULL,
[TotalAmount] [money] NOT NULL,
[LastUpdatedAt] [datetime] NOT NULL CONSTRAINT [DF_TChargingPolicyCharge_LastUpdatedAt] DEFAULT(GETDATE()),
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TChargingPolicyCharge_IsArchived] DEFAULT(0),
[Note] [varchar](250) NULL
)
GO
ALTER TABLE [dbo].[TChargingPolicyCharge] ADD CONSTRAINT [PK_TChargingPolicyCharge] PRIMARY KEY CLUSTERED ([ChargingPolicyChargeId])
GO
CREATE NONCLUSTERED INDEX [IDX_TChargingPolicyCharge_PolicyChargeId_TenantId] ON [dbo].[TChargingPolicyCharge] ([ChargingPolicyChargeId], [TenantId])
GO
CREATE NONCLUSTERED INDEX [IDX_TChargingPolicyCharge_PolicyBusinessId_TenantId] ON [dbo].[TChargingPolicyCharge] ([PolicyBusinessId], [TenantId]) INCLUDE ([ChargingPolicyChargeId], [ChargeDate])
GO