SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditPhi]
	@StampUser varchar (255),
	@PhiId bigint,
	@StampAction char(1)
AS

INSERT INTO TPhiAudit 
( PhiDeferredPeriod, Amount, Term, RetirementAge, 
		RefPremiumTypeId, RefOccupationBasisId, PrivateHospitalBenefit, RefFrequencyId, 
		ConcurrencyId, 
	PhiId, StampAction, StampDateTime, StampUser) 
Select PhiDeferredPeriod, Amount, Term, RetirementAge, 
		RefPremiumTypeId, RefOccupationBasisId, PrivateHospitalBenefit, RefFrequencyId, 
		ConcurrencyId, 
	PhiId, @StampAction, GetDate(), @StampUser
FROM TPhi
WHERE PhiId = @PhiId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
