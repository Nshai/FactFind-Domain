SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditEquityRelease]
	@StampUser varchar (255),
	@EquityReleaseId bigint,
	@StampAction char(1)
AS

INSERT INTO TEquityReleaseAudit 
( CRMContactId, releaseEquity, reduceOwnership, existingPolicies, 
		ConcurrencyId, 
	EquityReleaseId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, releaseEquity, reduceOwnership, existingPolicies, 
		ConcurrencyId, 
	EquityReleaseId, @StampAction, GetDate(), @StampUser
FROM TEquityRelease
WHERE EquityReleaseId = @EquityReleaseId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
