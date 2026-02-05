SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditWrapperProvider]
	@StampUser varchar (255),
	@WrapperProviderId bigint,
	@StampAction char(1)
AS

INSERT INTO TWrapperProviderAudit 
( RefPlanTypeId, RefProdProviderId, WrapAllowOtherProvidersFg, SippAllowOtherProvidersFg, 
		SsasAllowOtherProvidersFg, GroupSippAllowOtherProvidersFg, OffshoreBondAllowOtherProvidersFg,
		QropsAllowOtherProvidersFg, SuperAllowOtherProvidersFg, JuniorSIPPAllowOtherProvidersFg, QnupsAllowOtherProvidersFg,
		WrapInvestmentAllowOtherProvidersFg, PersonalPensionAllowOtherProvidersFg,
		OpenAnnuityAllowOtherProvidersFg,
		IncomeDrawdownAllowOtherProvidersFg,
		PhasedRetirementAllowOtherProvidersFg,
		RopsAllowOtherProvidersFg,
		InvestmentBondAllowOtherProvidersFg,
		PensionAllowOtherProvidersFg,
		SuperWrapAllowOtherProvidersFg,
		SelfManagedSuperFundAllowOtherProvidersFg,
		WrapperOnly, ConcurrencyId,
		WrapperProviderId, StampAction, StampDateTime, StampUser) 
Select RefPlanTypeId, RefProdProviderId, WrapAllowOtherProvidersFg, SippAllowOtherProvidersFg, 
		SsasAllowOtherProvidersFg, GroupSippAllowOtherProvidersFg, OffshoreBondAllowOtherProvidersFg,
		QropsAllowOtherProvidersFg, SuperAllowOtherProvidersFg, JuniorSIPPAllowOtherProvidersFg, QnupsAllowOtherProvidersFg,
		WrapInvestmentAllowOtherProvidersFg, PersonalPensionAllowOtherProvidersFg,
		OpenAnnuityAllowOtherProvidersFg,
		IncomeDrawdownAllowOtherProvidersFg,
		PhasedRetirementAllowOtherProvidersFg,
		RopsAllowOtherProvidersFg,
		InvestmentBondAllowOtherProvidersFg,
		PensionAllowOtherProvidersFg,
		SuperWrapAllowOtherProvidersFg,
		SelfManagedSuperFundAllowOtherProvidersFg,
		WrapperOnly, ConcurrencyId,
		WrapperProviderId, @StampAction, GetDate(), @StampUser
FROM TWrapperProvider
WHERE WrapperProviderId = @WrapperProviderId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
