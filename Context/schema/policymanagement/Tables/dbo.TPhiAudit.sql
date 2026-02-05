CREATE TABLE [dbo].[TPhiAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PhiDeferredPeriod] [int] NULL,
[Amount] [money] NULL,
[Term] [int] NULL,
[RetirementAge] [int] NULL,
[RefPremiumTypeId] [int] NULL,
[RefOccupationBasisId] [int] NULL,
[PrivateHospitalBenefit] [bit] NULL,
[RefFrequencyId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPhiAudit_ConcurrencyId] DEFAULT ((1)),
[PhiId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPhiAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPhiAudit] ADD CONSTRAINT [PK_TPhiAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TPhiAudit_PhiId_ConcurrencyId] ON [dbo].[TPhiAudit] ([PhiId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
