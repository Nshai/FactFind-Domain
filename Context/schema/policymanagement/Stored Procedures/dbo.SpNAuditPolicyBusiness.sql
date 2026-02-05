SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditPolicyBusiness]
	@StampUser varchar (255),
	@PolicyBusinessId bigint,
	@StampAction char(1)
AS

INSERT INTO TPolicyBusinessAudit
( PolicyDetailId, PolicyNumber, PractitionerId, ReplaceNotes,
		TnCCoachId, AdviceTypeId, BestAdvicePanelUsedFG, WaiverDefermentPeriod,
		IndigoClientId, SwitchFG, TotalRegularPremium, TotalLumpSum,
		MaturityDate, LifeCycleId, PolicyStartDate, PremiumType,
		AgencyNumber, ProviderAddress, OffPanelFg, BaseCurrency,
		ExpectedPaymentDate, ProductName, InvestmentTypeId, RiskRating,
		SequentialRef, ConcurrencyId, IsGuaranteedToProtectOriginalInvestment, ClientTypeId,
		PlanMigrationRef, UsePriceFeed, LowMaturityValue, MediumMaturityValue,
		HighMaturityValue, ProjectionDetails, TopupMasterPolicyBusinessId, ServicingUserId,
		PropositionTypeId,ParaplannerUserId,
	PolicyBusinessId, StampAction, StampDateTime, StampUser, GroupId, PerformanceStartDate,
	PerformanceEndDate, ProviderCode2, ProviderCode3)
Select PolicyDetailId, PolicyNumber, PractitionerId, ReplaceNotes,
		TnCCoachId, AdviceTypeId, BestAdvicePanelUsedFG, WaiverDefermentPeriod,
		IndigoClientId, SwitchFG, TotalRegularPremium, TotalLumpSum,
		MaturityDate, LifeCycleId, PolicyStartDate, PremiumType,
		AgencyNumber, ProviderAddress, OffPanelFg, BaseCurrency,
		ExpectedPaymentDate, ProductName, InvestmentTypeId, RiskRating,
		SequentialRef, ConcurrencyId, IsGuaranteedToProtectOriginalInvestment, ClientTypeId,
		PlanMigrationRef, UsePriceFeed, LowMaturityValue, MediumMaturityValue,
		HighMaturityValue, ProjectionDetails, TopupMasterPolicyBusinessId, ServicingUserId,
		PropositionTypeId,ParaplannerUserId,
	PolicyBusinessId, @StampAction, GetDate(), @StampUser, GroupId, PerformanceStartDate,
	PerformanceEndDate, ProviderCode2, ProviderCode3
FROM TPolicyBusiness
WHERE PolicyBusinessId = @PolicyBusinessId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
