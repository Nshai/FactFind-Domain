SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditBenefit]
	@StampUser varchar (255),
	@BenefitId bigint,
	@StampAction char(1)
AS

INSERT INTO TBenefitAudit
( BenefitAmount, PremiumWaiverWoc,BenefitDeferredPeriod,IsRated,BenefitOptions, RefPeriodTypeId,RefBenefitPeriodId, RefQualificationPeriodId,
RefTotalPermanentDisabilityTypeId,RefFrequencyId,IndigoClientId, SplitBenefitAmount,SplitBenefitDeferredPeriod,RefSplitFrequencyId, ConcurrencyId, BenefitId, StampAction, StampDateTime, StampUser
,PensionCommencementLumpSum,IsSpousesBenefit,SpousesOrDependentsPercentage,GuaranteedPeriod,IsProportion,PCLSPaidById,IsCapitalValueProtected,CapitalValueProtectedAmount,GADMaximumIncomeLimit
,GADCalculationDate,GuaranteedMinimumIncome,LumpSumDeathBenefitAmount,DeferredPeriodIntervalId,SplitDeferredPeriodIntervalId, IsOverlap,OtherBenefitPeriodText,PlanMigrationRef,PolicyBusinessId,
IsPre75)
SELECT BenefitAmount,PremiumWaiverWoc,BenefitDeferredPeriod,IsRated,BenefitOptions,RefPeriodTypeId,RefBenefitPeriodId, RefQualificationPeriodId,
RefTotalPermanentDisabilityTypeId, RefFrequencyId,IndigoClientId,SplitBenefitAmount,SplitBenefitDeferredPeriod,RefSplitFrequencyId, ConcurrencyId, BenefitId, @StampAction, GetDate(), @StampUser
,PensionCommencementLumpSum,IsSpousesBenefit,SpousesOrDependentsPercentage,GuaranteedPeriod,IsProportion,PCLSPaidById,IsCapitalValueProtected,CapitalValueProtectedAmount
,GADMaximumIncomeLimit,GADCalculationDate,GuaranteedMinimumIncome,LumpSumDeathBenefitAmount,DeferredPeriodIntervalId,SplitDeferredPeriodIntervalId,IsOverlap,OtherBenefitPeriodText,PlanMigrationRef,PolicyBusinessId,
IsPre75
FROM TBenefit
WHERE BenefitId = @BenefitId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
