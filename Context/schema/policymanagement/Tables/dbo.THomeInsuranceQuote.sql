CREATE TABLE [dbo].[THomeInsuranceQuote]
(
[QuoteId] [int] NOT NULL,
[RefPropertyTypeId] [int] NOT NULL,
[Postcode] [varchar] (10)  NULL,
[NumberOfBedrooms] [int] NOT NULL,
[IncludeAccidentalBuildingDamageCover] [bit] NOT NULL CONSTRAINT [DF_THomeInsuranceQuote_IncludeAccidentalBuildingDamageCover] DEFAULT ((0)),
[IncludeAccidentalContentsDamageCover] [bit] NOT NULL CONSTRAINT [DF_THomeInsuranceQuote_IncludeAccidentalContentsDamageCover] DEFAULT ((0)),
[NoClaimYearsBuilding] [int] NOT NULL CONSTRAINT [DF_THomeInsuranceQuote_NoClaimYearsBuilding] DEFAULT ((0)),
[NoClaimYearsContents] [int] NOT NULL CONSTRAINT [DF_THomeInsuranceQuote_NoClaimYearsContents] DEFAULT ((0)),
[RefCoverTypeId] [int] NOT NULL,
[BuildYear] [int] NOT NULL,
[UnspecifiedItemAmount] [money] NULL,
[IncludeBuildingsExtraCover] [bit] NOT NULL CONSTRAINT [DF_THomeInsuranceQuote_IncludeBuildingsExtraCover] DEFAULT ((0)),
[IncludeContentsExtraCover] [bit] NOT NULL CONSTRAINT [DF_THomeInsuranceQuote_IncludeContentsExtraCover] DEFAULT ((0)),
[IncludeHomeEmergencyCover] [bit] NOT NULL CONSTRAINT [DF_THomeInsuranceQuote_IncludeHomeEmergencyCover] DEFAULT ((0)),
[IncludeLegalAssistanceCover] [bit] NOT NULL CONSTRAINT [DF_THomeInsuranceQuote_IncludeLegalAssistanceCover] DEFAULT ((0)),
[PolicyExcess] [money] NULL,
[IsMasonryBuild] [tinyint] NOT NULL CONSTRAINT [DF_THomeInsuranceQuote_IsMasonryBuild] DEFAULT ((2)),
[IsPermanentlyOccupied] [tinyint] NOT NULL CONSTRAINT [DF_THomeInsuranceQuote_IsPermanentlyOccupied] DEFAULT ((2)),
[HasSubsidence] [tinyint] NOT NULL CONSTRAINT [DF_THomeInsuranceQuote_HasSubsidence] DEFAULT ((2)),
[ApplicantOrFamilyHasConviction] [tinyint] NOT NULL CONSTRAINT [DF_THomeInsuranceQuote_ApplicantOrFamilyHasConviction] DEFAULT ((2)),
[UnoccupiedSixtyPlusDays] [tinyint] NOT NULL CONSTRAINT [DF_THomeInsuranceQuote_UnoccupiedSixtyPlusDays] DEFAULT ((2)),
[UsedForBusinessPurposes] [tinyint] NOT NULL CONSTRAINT [DF_THomeInsuranceQuote_UsedForBusinessPurposes] DEFAULT ((2)),
[ApplicantHasPreviousClaims] [tinyint] NOT NULL CONSTRAINT [DF_THomeInsuranceQuote_ApplicantHasPreviousClaims] DEFAULT ((2)),
[IsFurnished] [bit] NOT NULL CONSTRAINT [DF_THomeInsuranceQuote_IsFurnished] DEFAULT ((0)),
[NoOfPSLandlordPolicy] [int] NOT NULL CONSTRAINT [DF_THomeInsuranceQuote_NoOfPSLandlordPolicy] DEFAULT ((0)),
[IsPrivateIndividual] [tinyint] NOT NULL CONSTRAINT [DF_THomeInsuranceQuote_IsPrivateIndividual] DEFAULT ((2)),
[HasInsuranceDeclined] [tinyint] NOT NULL CONSTRAINT [DF_THomeInsuranceQuote_HasInsuranceDeclined] DEFAULT ((2)),
[UsedForAsylumSeekers] [tinyint] NOT NULL CONSTRAINT [DF_THomeInsuranceQuote_UsedForAsylumSeekers] DEFAULT ((2)),
[IsDirectTenancyAgreement] [tinyint] NOT NULL CONSTRAINT [DF_THomeInsuranceQuote_IsDirectTenancyAgreement] DEFAULT ((2)),
[HasLessThanSixIndividuals] [tinyint] NOT NULL CONSTRAINT [DF_THomeInsuranceQuote_HasLessThanSixIndividuals] DEFAULT ((2)),
[IsSelfContainedUnits] [tinyint] NOT NULL CONSTRAINT [DF_THomeInsuranceQuote_IsSelfContainedUnits] DEFAULT ((2)),
[HasPropertyFlooded] [tinyint] NOT NULL CONSTRAINT [DF_THomeInsuranceQuote_HasPropertyFlooded] DEFAULT ((2)),
[IncludeStudentTenants] [bit] NOT NULL CONSTRAINT [DF_THomeInsuranceQuote_IncludeStudentTenants] DEFAULT ((0)),
[IncludeDsstenants] [bit] NOT NULL CONSTRAINT [DF_THomeInsuranceQuote_includeDsstenants] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_THomeInsuranceQuote_ConcurrencyId] DEFAULT ((1)),
[PropertyDetailId] [int] NULL
)
GO
ALTER TABLE [dbo].[THomeInsuranceQuote] ADD CONSTRAINT [PK_THomeInsuranceQuote] PRIMARY KEY CLUSTERED  ([QuoteId])
GO
ALTER TABLE [dbo].[THomeInsuranceQuote] WITH CHECK ADD CONSTRAINT [FK_THomeInsuranceQuote_ApplicantHasPreviousClaims_TRefYesNoResponse] FOREIGN KEY ([ApplicantHasPreviousClaims]) REFERENCES [dbo].[TRefYesNoResponse] ([RefYesNoResponseId])
GO
ALTER TABLE [dbo].[THomeInsuranceQuote] WITH CHECK ADD CONSTRAINT [FK_THomeInsuranceQuote_ApplicantOrFamilyHasConviction_TRefYesNoResponse] FOREIGN KEY ([ApplicantOrFamilyHasConviction]) REFERENCES [dbo].[TRefYesNoResponse] ([RefYesNoResponseId])
GO
ALTER TABLE [dbo].[THomeInsuranceQuote] WITH CHECK ADD CONSTRAINT [FK_THomeInsuranceQuote_HasInsuranceDeclined_TRefYesNoResponse] FOREIGN KEY ([HasInsuranceDeclined]) REFERENCES [dbo].[TRefYesNoResponse] ([RefYesNoResponseId])
GO
ALTER TABLE [dbo].[THomeInsuranceQuote] WITH CHECK ADD CONSTRAINT [FK_THomeInsuranceQuote_HasLessThanSixIndividuals_TRefYesNoResponse] FOREIGN KEY ([HasLessThanSixIndividuals]) REFERENCES [dbo].[TRefYesNoResponse] ([RefYesNoResponseId])
GO
ALTER TABLE [dbo].[THomeInsuranceQuote] WITH CHECK ADD CONSTRAINT [FK_THomeInsuranceQuote_HasPropertyFlooded_TRefYesNoResponse] FOREIGN KEY ([HasPropertyFlooded]) REFERENCES [dbo].[TRefYesNoResponse] ([RefYesNoResponseId])
GO
ALTER TABLE [dbo].[THomeInsuranceQuote] WITH CHECK ADD CONSTRAINT [FK_THomeInsuranceQuote_HasSubsidence_TRefYesNoResponse] FOREIGN KEY ([HasSubsidence]) REFERENCES [dbo].[TRefYesNoResponse] ([RefYesNoResponseId])
GO
ALTER TABLE [dbo].[THomeInsuranceQuote] WITH CHECK ADD CONSTRAINT [FK_THomeInsuranceQuote_IsDirectTenancyAgreement_TRefYesNoResponse] FOREIGN KEY ([IsDirectTenancyAgreement]) REFERENCES [dbo].[TRefYesNoResponse] ([RefYesNoResponseId])
GO
ALTER TABLE [dbo].[THomeInsuranceQuote] WITH CHECK ADD CONSTRAINT [FK_THomeInsuranceQuote_IsMasonryBuild_TRefYesNoResponse] FOREIGN KEY ([IsMasonryBuild]) REFERENCES [dbo].[TRefYesNoResponse] ([RefYesNoResponseId])
GO
ALTER TABLE [dbo].[THomeInsuranceQuote] WITH CHECK ADD CONSTRAINT [FK_THomeInsuranceQuote_IsPermanentlyOccupied_TRefYesNoResponse] FOREIGN KEY ([IsPermanentlyOccupied]) REFERENCES [dbo].[TRefYesNoResponse] ([RefYesNoResponseId])
GO
ALTER TABLE [dbo].[THomeInsuranceQuote] WITH CHECK ADD CONSTRAINT [FK_THomeInsuranceQuote_IsPrivateIndividual_TRefYesNoResponse] FOREIGN KEY ([IsPrivateIndividual]) REFERENCES [dbo].[TRefYesNoResponse] ([RefYesNoResponseId])
GO
ALTER TABLE [dbo].[THomeInsuranceQuote] WITH CHECK ADD CONSTRAINT [FK_THomeInsuranceQuote_IsSelfContainedUnits_TRefYesNoResponse] FOREIGN KEY ([IsSelfContainedUnits]) REFERENCES [dbo].[TRefYesNoResponse] ([RefYesNoResponseId])
GO
ALTER TABLE [dbo].[THomeInsuranceQuote] WITH CHECK ADD CONSTRAINT [FK_THomeInsuranceQuote_TQuote] FOREIGN KEY ([QuoteId]) REFERENCES [dbo].[TQuote] ([QuoteId])
GO
ALTER TABLE [dbo].[THomeInsuranceQuote] WITH CHECK ADD CONSTRAINT [FK_THomeInsuranceQuote_TRefCoverType] FOREIGN KEY ([RefCoverTypeId]) REFERENCES [dbo].[TRefCoverType] ([RefCoverTypeId])
GO
ALTER TABLE [dbo].[THomeInsuranceQuote] WITH CHECK ADD CONSTRAINT [FK_THomeInsuranceQuote_TRefPropertyType] FOREIGN KEY ([RefPropertyTypeId]) REFERENCES [dbo].[TRefPropertyType] ([RefPropertyTypeId])
GO
ALTER TABLE [dbo].[THomeInsuranceQuote] WITH CHECK ADD CONSTRAINT [FK_THomeInsuranceQuote_UnoccupiedSixtyPlusDays_TRefYesNoResponse] FOREIGN KEY ([UnoccupiedSixtyPlusDays]) REFERENCES [dbo].[TRefYesNoResponse] ([RefYesNoResponseId])
GO
ALTER TABLE [dbo].[THomeInsuranceQuote] WITH CHECK ADD CONSTRAINT [FK_THomeInsuranceQuote_UsedForAsylumSeekers_TRefYesNoResponse] FOREIGN KEY ([UsedForAsylumSeekers]) REFERENCES [dbo].[TRefYesNoResponse] ([RefYesNoResponseId])
GO
ALTER TABLE [dbo].[THomeInsuranceQuote] WITH CHECK ADD CONSTRAINT [FK_THomeInsuranceQuote_UsedForBusinessPurposes_TRefYesNoResponse] FOREIGN KEY ([UsedForBusinessPurposes]) REFERENCES [dbo].[TRefYesNoResponse] ([RefYesNoResponseId])
GO
