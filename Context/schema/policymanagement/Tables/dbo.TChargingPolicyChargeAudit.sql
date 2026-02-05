CREATE TABLE [dbo].[TChargingPolicyChargeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ChargingPolicyChargeId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[ChargeDate] [datetime] NOT NULL,
[ChargeType] [int] NOT NULL,
[TotalAmount] [money] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NOT NULL CONSTRAINT [DF_TChargingPolicyChargeAudit_StampDateTime] DEFAULT (GETDATE()),
[StampUser] [varchar] (255) NULL,
[LastUpdatedAt] [datetime] NOT NULL CONSTRAINT [DF_TChargingPolicyChargeAudit_LastUpdatedAt] DEFAULT(GETDATE()),
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TChargingPolicyChargeAudit_IsArchived] DEFAULT(0),
[Note] [varchar](250) NULL
)
GO

ALTER TABLE [dbo].[TChargingPolicyChargeAudit] ADD CONSTRAINT [PK_TChargingPolicyChargeAudit] PRIMARY KEY CLUSTERED ([AuditId])
GO

CREATE NONCLUSTERED INDEX [IDX_TChargingPolicyCharge_PolicyChargeId_TenantId] ON [dbo].[TChargingPolicyChargeAudit] ([ChargingPolicyChargeId], [TenantId])
GO