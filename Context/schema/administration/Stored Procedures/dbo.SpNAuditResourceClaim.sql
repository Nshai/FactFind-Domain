SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditResourceClaim]
	@StampUser varchar (255),
	@ResourceClaimId bigint,
	@StampAction char(1)
AS

INSERT INTO TResourceClaimAudit 
( ResourceClaimId, Resource, Description, Action, StampAction, StampDateTime, StampUser) 
Select ResourceClaimId,Resource, Description, Action, @StampAction, GetDate(), @StampUser
FROM TResourceClaim
WHERE ResourceClaimId = @ResourceClaimId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO