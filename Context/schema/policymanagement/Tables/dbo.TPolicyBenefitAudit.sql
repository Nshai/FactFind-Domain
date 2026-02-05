CREATE TABLE [dbo].[TPolicyBenefitAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NULL,
[ConcurrencyId] [int] NOT NULL,
[PolicyBenefitId] [int] NOT NULL,
[FirstLifeFg] [bit] NULL CONSTRAINT [DF_TPolicyBenefitAudit_FirstLifeFg] DEFAULT ((1)),
[CRMContactId] [int] NULL,
[LifeCoverId] [int] NULL,
[FamilyBenefitId] [int] NULL,
[InTrustId] [int] NULL,
[WaiverDeferredFg] [bit] NULL,
[CriticalIllnessId] [int] NULL,
[PhiId] [int] NULL,
[WaiverDeferredPeriod] [int] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_Tmp_TPolicyBenefitAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPolicyBenefitAudit] ADD CONSTRAINT [PK_TPolicyBenefitAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TPolicyBenefitAudit_PolicyBenefitId_ConcurrencyId] ON [dbo].[TPolicyBenefitAudit] ([PolicyBenefitId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
