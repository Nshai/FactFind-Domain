CREATE TABLE [dbo].[TPolicyBenefit]
(
[PolicyBenefitId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NULL,
[FirstLifeFg] [bit] NULL CONSTRAINT [DF_TPolicyBenefit_FirstLifeFg] DEFAULT ((1)),
[CRMContactId] [int] NULL,
[LifeCoverId] [int] NULL,
[CriticalIllnessId] [int] NULL,
[PhiId] [int] NULL,
[FamilyBenefitId] [int] NULL,
[InTrustId] [int] NULL,
[WaiverDeferredFg] [bit] NULL,
[WaiverDeferredPeriod] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyBenefit_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPolicyBenefit] ADD CONSTRAINT [PK_TPolicyBenefit_PolicyBenefitId] PRIMARY KEY NONCLUSTERED  ([PolicyBenefitId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyBenefit_CriticalIllnessId] ON [dbo].[TPolicyBenefit] ([CriticalIllnessId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyBenefit_CRMContactId] ON [dbo].[TPolicyBenefit] ([CRMContactId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyBenefit_LifeCoverId] ON [dbo].[TPolicyBenefit] ([LifeCoverId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyBenefit_PhiId] ON [dbo].[TPolicyBenefit] ([PhiId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyBenefit_PolicyBusinessId] ON [dbo].[TPolicyBenefit] ([PolicyBusinessId])
GO
ALTER TABLE [dbo].[TPolicyBenefit] ADD CONSTRAINT [FK_TPolicyBenefit_CriticalIllnessId_CriticalIllnessId] FOREIGN KEY ([CriticalIllnessId]) REFERENCES [dbo].[TCriticalIllness] ([CriticalIllnessId])
GO
ALTER TABLE [dbo].[TPolicyBenefit] ADD CONSTRAINT [FK_TPolicyBenefit_LifeCoverId_LifeCoverId] FOREIGN KEY ([LifeCoverId]) REFERENCES [dbo].[TLifeCover] ([LifeCoverId])
GO
ALTER TABLE [dbo].[TPolicyBenefit] ADD CONSTRAINT [FK_TPolicyBenefit_PhiId_PhiId] FOREIGN KEY ([PhiId]) REFERENCES [dbo].[TPhi] ([PhiId])
GO
ALTER TABLE [dbo].[TPolicyBenefit] WITH CHECK ADD CONSTRAINT [FK_TPolicyBenefit_PolicyBusinessId_PolicyBusinessId] FOREIGN KEY ([PolicyBusinessId]) REFERENCES [dbo].[TPolicyBusiness] ([PolicyBusinessId])
GO
create index IX_INCL_TPolicyBenefit_PolicyBusinessId on TPolicyBenefit (PolicyBusinessID) include (WaiverDeferredFg, WaiverDeferredPeriod)
go
