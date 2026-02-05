SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditCorporateLiability]
	@StampUser varchar (255),
	@CorporateLiabilityId bigint,
	@StampAction char(1)
AS

INSERT INTO TCorporateLiabilityAudit 
( CRMContactId, Nature, OutstandingAmount, RepaymentMethod, 
		RepaymentDate, LiabilityName, LiabilityType, ConcurrencyId, 
		
	CorporateLiabilityId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, Nature, OutstandingAmount, RepaymentMethod, 
		RepaymentDate, LiabilityName, LiabilityType, ConcurrencyId, 
		
	CorporateLiabilityId, @StampAction, GetDate(), @StampUser
FROM TCorporateLiability
WHERE CorporateLiabilityId = @CorporateLiabilityId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
