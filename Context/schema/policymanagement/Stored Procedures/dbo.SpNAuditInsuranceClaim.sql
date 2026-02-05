SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditInsuranceClaim]
	@StampUser varchar (255),
	@InsuranceClaimId bigint,
	@StampAction char(1)
AS

INSERT INTO TInsuranceClaimAudit 
(QuoteId,RefInsuranceClaimTypeId,Value,DateOfClaim,ConcurrencyId,InsuranceClaimId,StampAction,StampDateTime,StampUser)
SELECT  QuoteId,RefInsuranceClaimTypeId,Value,DateOfClaim,ConcurrencyId,
	InsuranceClaimId, @StampAction, GetDate(), @StampUser
FROM TInsuranceClaim
WHERE InsuranceClaimId = @InsuranceClaimId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
