SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditClientShare]
	@StampUser varchar (255),
	@ClientShareId bigint,
	@StampAction char(1)
AS

INSERT INTO TClientShareAudit 
	( 
		[ClientShareId], [ClientPartyId], [SharedByCRMContactId], [SharedToCRMContactId], [StartDate], [EndDate], 
		[ShareEndedByCRMContactId], [IsShareActive], [ShareIdentifier], [OrganiserActivityId], 
		[TenantId], [ConcurrencyId], StampAction, StampDateTime, StampUser
		) 
Select [ClientShareId], [ClientPartyId], [SharedByCRMContactId], [SharedToCRMContactId], [StartDate], [EndDate], 
	   [ShareEndedByCRMContactId], [IsShareActive], [ShareIdentifier], [OrganiserActivityId], 
	   [TenantId], [ConcurrencyId], @StampAction, GetDate(), @StampUser
FROM TClientShare
WHERE ClientShareId = @ClientShareId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
