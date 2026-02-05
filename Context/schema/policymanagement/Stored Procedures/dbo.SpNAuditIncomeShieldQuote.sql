SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditIncomeShieldQuote]
	@StampUser varchar (255),
	@QuoteId bigint,
	@StampAction char(1)
AS

INSERT INTO TIncomeShieldQuoteAudit
(
RefAsuPhiCoverTypeId, RefDeferredPremiumLengthId, IsTransferCover, BenefitAmount, IsNewLoan, RefPaymentshieldBenefitPeriodId,
RefEmploymentTypeId, QualPeriodUnemploymentId, QualTypeUnemploymentId, QualPeriodDisabilityId, QualTypeDisabilityId,
IsLivingInTheUK, IsTemporaryWork, IsTwelveMonthEmployed, IsAwareOfPreExistingMedicalExclusions, IsAwareOfClaim, AwareOfClaimAdditionalInfo,
IsJobAtRisk, IsCutInWorkForce, IsEmployerIntoAdministrationLiquidation, IsRegisteredUnemployed, RefPhiTransferCoverTypeId, BenefitInsured,
CurrentProviderID, StartDate, HasMadeUnemploymentClaim, ConcurrencyId, QuoteId, StampAction, StampDateTime,  StampUser, NewLoanStartDate,  IsReferred)

SELECT 
RefAsuPhiCoverTypeId, RefDeferredPremiumLengthId, IsTransferCover,  BenefitAmount, IsNewLoan, RefPaymentshieldBenefitPeriodId, 
RefEmploymentTypeId, QualPeriodUnemploymentId, QualTypeUnemploymentId, QualPeriodDisabilityId, QualTypeDisabilityId,
IsLivingInTheUK, IsTemporaryWork, IsTwelveMonthEmployed, IsAwareOfPreExistingMedicalExclusions, IsAwareOfClaim, AwareOfClaimAdditionalInfo,
IsJobAtRisk, IsCutInWorkForce, IsEmployerIntoAdministrationLiquidation, IsRegisteredUnemployed, RefPhiTransferCoverTypeId, BenefitInsured,
CurrentProviderID, StartDate, HasMadeUnemploymentClaim, ConcurrencyId, QuoteId, @StampAction, GetDate(),  @StampUser, NewLoanStartDate, IsReferred
FROM TIncomeShieldQuote
WHERE QuoteId = @QuoteId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
