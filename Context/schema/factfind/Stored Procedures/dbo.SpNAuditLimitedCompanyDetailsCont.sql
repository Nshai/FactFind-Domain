SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditLimitedCompanyDetailsCont]
	@StampUser varchar (255),
	@LimitedCompanyDetailsContId bigint,
	@StampAction char(1)
AS

INSERT INTO TLimitedCompanyDetailsContAudit 
( CRMContactId, IncorporationRegistrationNumber, ProvideForLossYesNo, ProductProvider, 
		DateCoverEffected, RenewablePremiums, SumAssured, Term, 
		AnnualCost, DisablementCoverYesNo, DirectorsProtectedYesNo, ConcurrencyId, 
		
	LimitedCompanyDetailsContId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, IncorporationRegistrationNumber, ProvideForLossYesNo, ProductProvider, 
		DateCoverEffected, RenewablePremiums, SumAssured, Term, 
		AnnualCost, DisablementCoverYesNo, DirectorsProtectedYesNo, ConcurrencyId, 
		
	LimitedCompanyDetailsContId, @StampAction, GetDate(), @StampUser
FROM TLimitedCompanyDetailsCont
WHERE LimitedCompanyDetailsContId = @LimitedCompanyDetailsContId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
