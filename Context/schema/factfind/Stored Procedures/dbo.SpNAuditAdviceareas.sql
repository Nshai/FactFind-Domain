SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditAdviceareas]
	@StampUser varchar (255),
	@AdviceareasId bigint,
	@StampAction char(1)
AS

INSERT INTO TAdviceareasAudit (
	CRMContactId, DateOfFirstInterview, AnybodyElsePresent, AnybodyElsePresentDetails, UnprotectedLiabilities, SufferInIllness, ProtectionAdvice, 
	HasPensionProvision, PensionProvisionProvidesRetirementIncome, RetirementAdvice, HasRegularSavings, HasCashDeposits, InvestmentAdvice, 
	HasValidWill, IsWillUptoDate, EstateAdvice, AdviceOption, PA, RPA, SIA, ProtectAgainstDeath, ProtectAgainstIllness, ProtectEarnings, 
	ProvideRetirementIncome, ProtectMortgage, PMI, InvestingCapital, RegSavings, InheritanceTaxPlanning, SchoolFeesPlanning, LongTermCare, 
	PurchasingProperty, RemortgagingProperty, RaisingCapital, MortgageAdvice, ConcurrencyId, AdviceareasId, StampAction, StampDateTime, StampUser, 
	RefInterviewTypeId, ClientsPresent, [HasBeenAdvisedToMakeWill])
SELECT
	CRMContactId, DateOfFirstInterview, AnybodyElsePresent, AnybodyElsePresentDetails, UnprotectedLiabilities, SufferInIllness, ProtectionAdvice, 
	HasPensionProvision, PensionProvisionProvidesRetirementIncome, RetirementAdvice, HasRegularSavings, HasCashDeposits, InvestmentAdvice, 
	HasValidWill, IsWillUptoDate, EstateAdvice, AdviceOption, PA, RPA, SIA, ProtectAgainstDeath, ProtectAgainstIllness, ProtectEarnings, 
	ProvideRetirementIncome, ProtectMortgage, PMI, InvestingCapital, RegSavings, InheritanceTaxPlanning, SchoolFeesPlanning, LongTermCare, 
	PurchasingProperty, RemortgagingProperty, RaisingCapital, MortgageAdvice, ConcurrencyId, AdviceareasId, @StampAction, GETDATE(), @StampUser,
	RefInterviewTypeId, ClientsPresent, [HasBeenAdvisedToMakeWill]
FROM 
	TAdviceareas
WHERE 
	AdviceareasId = @AdviceareasId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
