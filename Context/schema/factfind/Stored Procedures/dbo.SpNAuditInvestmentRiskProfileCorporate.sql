SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditInvestmentRiskProfileCorporate]
	@StampUser varchar (255),
	@InvestmentRiskProfileCorporateId bigint,
	@StampAction char(1)
AS

INSERT INTO TInvestmentRiskProfileCorporateAudit 
( CRMContactId, Owner, InvestmentRiseAndFall, OppToBuyCheaper, 
		BusinessInvestmentsCouldFall, PreferSecurityOfBank, RapidRiseAndFall, Term, 
		IncomeLevel, SpecificAmount, MakeOwnInvestmentDecisions, DoYouWantEmergencyFunds, 
		EmergencyAmount, Notes, ConcurrencyId, 
	InvestmentRiskProfileCorporateId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, Owner, InvestmentRiseAndFall, OppToBuyCheaper, 
		BusinessInvestmentsCouldFall, PreferSecurityOfBank, RapidRiseAndFall, Term, 
		IncomeLevel, SpecificAmount, MakeOwnInvestmentDecisions, DoYouWantEmergencyFunds, 
		EmergencyAmount, Notes, ConcurrencyId, 
	InvestmentRiskProfileCorporateId, @StampAction, GetDate(), @StampUser
FROM TInvestmentRiskProfileCorporate
WHERE InvestmentRiskProfileCorporateId = @InvestmentRiskProfileCorporateId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
