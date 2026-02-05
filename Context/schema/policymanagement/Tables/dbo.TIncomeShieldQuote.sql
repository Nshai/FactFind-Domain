CREATE TABLE [dbo].[TIncomeShieldQuote]
(
[QuoteId] [int] NOT NULL,
[RefAsuPhiCoverTypeId] [int] NOT NULL,
[RefDeferredPremiumLengthId] [int] NOT NULL,
[IsTransferCover] [tinyint] NOT NULL CONSTRAINT [DF_TIncomeShieldQuote_IsTransferCover] DEFAULT ((0)),
[BenefitAmount] [money] NULL,
[IsNewLoan] [tinyint] NOT NULL CONSTRAINT [DF_TIncomeShieldQuote_IsNewLoan] DEFAULT ((0)),
[RefPaymentshieldBenefitPeriodId] [int] NOT NULL,
[RefEmploymentTypeId] [int] NOT NULL,
[QualPeriodUnemploymentId] [int] NOT NULL,
[QualTypeUnemploymentId] [int] NOT NULL,
[QualPeriodDisabilityId] [int] NOT NULL,
[QualTypeDisabilityId] [int] NOT NULL,
[IsLivingInTheUK] [tinyint] NOT NULL CONSTRAINT [DF_TIncomeShieldQuote_IsLivingInTheUK] DEFAULT ((0)),
[IsTemporaryWork] [tinyint] NOT NULL CONSTRAINT [DF_TIncomeShieldQuote_IsTemporaryWork] DEFAULT ((0)),
[IsTwelveMonthEmployed] [tinyint] NOT NULL CONSTRAINT [DF_TIncomeShieldQuote_IsTwelveMonthEmployed] DEFAULT ((0)),
[IsAwareOfPreExistingMedicalExclusions] [tinyint] NOT NULL CONSTRAINT [DF_TIncomeShieldQuote_IsAwareOfPreExistingMedicalExclusions] DEFAULT ((0)),
[IsAwareOfClaim] [tinyint] NOT NULL CONSTRAINT [DF_TIncomeShieldQuote_IsAwareOfClaim] DEFAULT ((0)),
[AwareOfClaimAdditionalInfo] [varchar] (255)  NULL,
[IsJobAtRisk] [tinyint] NOT NULL CONSTRAINT [DF_TIncomeShieldQuote_IsJobAtRisk] DEFAULT ((0)),
[IsCutInWorkForce] [tinyint] NOT NULL CONSTRAINT [DF_TIncomeShieldQuote_IsCutInWorkForce] DEFAULT ((0)),
[IsEmployerIntoAdministrationLiquidation] [tinyint] NOT NULL CONSTRAINT [DF_TIncomeShieldQuote_IsEmployerIntoAdministrationLiquidation] DEFAULT ((0)),
[IsRegisteredUnemployed] [tinyint] NOT NULL CONSTRAINT [DF_TIncomeShieldQuote_IsRegisteredUnemployed] DEFAULT ((0)),
[RefPhiTransferCoverTypeId] [int] NOT NULL,
[BenefitInsured] [money] NULL,
[CurrentProviderID] [int] NULL,
[StartDate] [datetime] NULL,
[HasMadeUnemploymentClaim] [tinyint] NOT NULL CONSTRAINT [DF_TIncomeShieldQuote_HasMadeUnemploymentClaim] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIncomeShieldQuote_ConcurrencyId] DEFAULT ((1)),
[NewLoanStartDate] [datetime] NULL,
[IsReferred] [bit] NULL,
[HasArrangedCredit] [int] NULL
)
GO
ALTER TABLE [dbo].[TIncomeShieldQuote] ADD CONSTRAINT [PK_TIncomeShieldQuote] PRIMARY KEY CLUSTERED  ([QuoteId])
GO
ALTER TABLE [dbo].[TIncomeShieldQuote] WITH CHECK ADD CONSTRAINT [FK_TIncomeShieldQuote_HasMadeUnemploymentClaim_TRefYesNoResponse] FOREIGN KEY ([HasMadeUnemploymentClaim]) REFERENCES [dbo].[TRefYesNoResponse] ([RefYesNoResponseId])
GO
ALTER TABLE [dbo].[TIncomeShieldQuote] WITH CHECK ADD CONSTRAINT [FK_TIncomeShieldQuote_IsAwareOfClaim_TRefYesNoResponse] FOREIGN KEY ([IsAwareOfClaim]) REFERENCES [dbo].[TRefYesNoResponse] ([RefYesNoResponseId])
GO
ALTER TABLE [dbo].[TIncomeShieldQuote] WITH CHECK ADD CONSTRAINT [FK_TIncomeShieldQuote_IsAwareOfPreExistingMedicalExclusions_TRefYesNoResponse] FOREIGN KEY ([IsAwareOfPreExistingMedicalExclusions]) REFERENCES [dbo].[TRefYesNoResponse] ([RefYesNoResponseId])
GO
ALTER TABLE [dbo].[TIncomeShieldQuote] WITH CHECK ADD CONSTRAINT [FK_TIncomeShieldQuote_IsCutInWorkForce_TRefYesNoResponse] FOREIGN KEY ([IsCutInWorkForce]) REFERENCES [dbo].[TRefYesNoResponse] ([RefYesNoResponseId])
GO
ALTER TABLE [dbo].[TIncomeShieldQuote] WITH CHECK ADD CONSTRAINT [FK_TIncomeShieldQuote_IsEmployerIntoAdministrationLiquidation_TRefYesNoResponse] FOREIGN KEY ([IsEmployerIntoAdministrationLiquidation]) REFERENCES [dbo].[TRefYesNoResponse] ([RefYesNoResponseId])
GO
ALTER TABLE [dbo].[TIncomeShieldQuote] WITH CHECK ADD CONSTRAINT [FK_TIncomeShieldQuote_IsJobAtRisk_TRefYesNoResponse] FOREIGN KEY ([IsJobAtRisk]) REFERENCES [dbo].[TRefYesNoResponse] ([RefYesNoResponseId])
GO
ALTER TABLE [dbo].[TIncomeShieldQuote] WITH CHECK ADD CONSTRAINT [FK_TIncomeShieldQuote_IsLivingInTheUK_TRefYesNoResponse] FOREIGN KEY ([IsLivingInTheUK]) REFERENCES [dbo].[TRefYesNoResponse] ([RefYesNoResponseId])
GO
ALTER TABLE [dbo].[TIncomeShieldQuote] WITH CHECK ADD CONSTRAINT [FK_TIncomeShieldQuote_IsNewLoan_TRefYesNoResponse] FOREIGN KEY ([IsNewLoan]) REFERENCES [dbo].[TRefYesNoResponse] ([RefYesNoResponseId])
GO
ALTER TABLE [dbo].[TIncomeShieldQuote] WITH CHECK ADD CONSTRAINT [FK_TIncomeShieldQuote_IsRegisteredUnemployed_TRefYesNoResponse] FOREIGN KEY ([IsRegisteredUnemployed]) REFERENCES [dbo].[TRefYesNoResponse] ([RefYesNoResponseId])
GO
ALTER TABLE [dbo].[TIncomeShieldQuote] WITH CHECK ADD CONSTRAINT [FK_TIncomeShieldQuote_IsTemporaryWork_TRefYesNoResponse] FOREIGN KEY ([IsTransferCover]) REFERENCES [dbo].[TRefYesNoResponse] ([RefYesNoResponseId])
GO
ALTER TABLE [dbo].[TIncomeShieldQuote] WITH CHECK ADD CONSTRAINT [FK_TIncomeShieldQuote_IsTransferCover_TRefYesNoResponse] FOREIGN KEY ([IsTransferCover]) REFERENCES [dbo].[TRefYesNoResponse] ([RefYesNoResponseId])
GO
ALTER TABLE [dbo].[TIncomeShieldQuote] WITH CHECK ADD CONSTRAINT [FK_TIncomeShieldQuote_IsTwelveMonthEmployed_TRefYesNoResponse] FOREIGN KEY ([IsTwelveMonthEmployed]) REFERENCES [dbo].[TRefYesNoResponse] ([RefYesNoResponseId])
GO
ALTER TABLE [dbo].[TIncomeShieldQuote] WITH CHECK ADD CONSTRAINT [FK_TIncomeShieldQuote_TRefUnEmpAndDisabilityBenefitPeriod_Disability] FOREIGN KEY ([QualPeriodDisabilityId]) REFERENCES [dbo].[TRefUnEmpAndDisabilityBenefitPeriod] ([RefUnEmpAndDisabilityBenefitPeriodId])
GO
ALTER TABLE [dbo].[TIncomeShieldQuote] WITH CHECK ADD CONSTRAINT [FK_TIncomeShieldQuote_TRefUnEmpAndDisabilityBenefitPeriod] FOREIGN KEY ([QualPeriodUnemploymentId]) REFERENCES [dbo].[TRefUnEmpAndDisabilityBenefitPeriod] ([RefUnEmpAndDisabilityBenefitPeriodId])
GO
ALTER TABLE [dbo].[TIncomeShieldQuote] WITH CHECK ADD CONSTRAINT [FK_TIncomeShieldQuote_TRefUnEmpAndDisabilityBenefitType_Disability] FOREIGN KEY ([QualTypeDisabilityId]) REFERENCES [dbo].[TRefUnEmpAndDisabilityBenefitType] ([RefUnEmpAndDisabilityBenefitTypeId])
GO
ALTER TABLE [dbo].[TIncomeShieldQuote] WITH CHECK ADD CONSTRAINT [FK_TIncomeShieldQuote_TRefUnEmpAndDisabilityBenefitType_Unemployment] FOREIGN KEY ([QualTypeUnemploymentId]) REFERENCES [dbo].[TRefUnEmpAndDisabilityBenefitType] ([RefUnEmpAndDisabilityBenefitTypeId])
GO
ALTER TABLE [dbo].[TIncomeShieldQuote] WITH CHECK ADD CONSTRAINT [FK_TIncomeShieldQuote_TQuote] FOREIGN KEY ([QuoteId]) REFERENCES [dbo].[TQuote] ([QuoteId])
GO
ALTER TABLE [dbo].[TIncomeShieldQuote] WITH CHECK ADD CONSTRAINT [FK_TIncomeShieldQuote_TRefAsuPhiCoverType] FOREIGN KEY ([RefAsuPhiCoverTypeId]) REFERENCES [dbo].[TRefAsuPhiCoverType] ([RefAsuPhiCoverTypeId])
GO
ALTER TABLE [dbo].[TIncomeShieldQuote] WITH CHECK ADD CONSTRAINT [FK_TIncomeShieldQuote_TRefDeferredPremiumLength] FOREIGN KEY ([RefDeferredPremiumLengthId]) REFERENCES [dbo].[TRefDeferredPremiumLength] ([RefDeferredPremiumLengthId])
GO
ALTER TABLE [dbo].[TIncomeShieldQuote] WITH CHECK ADD CONSTRAINT [FK_TIncomeShieldQuote_TRefEmploymentType] FOREIGN KEY ([RefEmploymentTypeId]) REFERENCES [dbo].[TRefEmploymentType] ([RefEmploymentTypeId])
GO
ALTER TABLE [dbo].[TIncomeShieldQuote] WITH CHECK ADD CONSTRAINT [FK_TIncomeShieldQuote_TRefPaymentshieldBenefitPeriod] FOREIGN KEY ([RefPaymentshieldBenefitPeriodId]) REFERENCES [dbo].[TRefPaymentshieldBenefitPeriod] ([RefPaymentshieldBenefitPeriodId])
GO
ALTER TABLE [dbo].[TIncomeShieldQuote] WITH CHECK ADD CONSTRAINT [FK_TIncomeShieldQuote_TRefPhiTransferCoverType] FOREIGN KEY ([RefPhiTransferCoverTypeId]) REFERENCES [dbo].[TRefPhiTransferCoverType] ([RefPhiTransferCoverTypeId])
GO
