CREATE TABLE [dbo].[TPhi]
(
[PhiId] [int] NOT NULL IDENTITY(1, 1),
[PhiDeferredPeriod] [int] NULL,
[Amount] [money] NULL,
[Term] [int] NULL,
[RetirementAge] [int] NULL,
[RefPremiumTypeId] [int] NULL,
[RefOccupationBasisId] [int] NULL,
[PrivateHospitalBenefit] [bit] NULL,
[RefFrequencyId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPhi_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPhi] ADD CONSTRAINT [PK_TPhi] PRIMARY KEY NONCLUSTERED  ([PhiId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TPhi_RefOccupationBasisId] ON [dbo].[TPhi] ([RefOccupationBasisId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TPhi_RefPremiumTypeId] ON [dbo].[TPhi] ([RefPremiumTypeId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TPhi] ADD CONSTRAINT [FK_TPhi_RefOccupationBasisId_RefOccupationBasisId] FOREIGN KEY ([RefOccupationBasisId]) REFERENCES [dbo].[TRefOccupationBasis] ([RefOccupationBasisId])
GO
ALTER TABLE [dbo].[TPhi] ADD CONSTRAINT [FK_TPhi_RefPremiumTypeId_RefPremiumTypeId] FOREIGN KEY ([RefPremiumTypeId]) REFERENCES [dbo].[TRefPremiumType] ([RefPremiumTypeId])
GO
