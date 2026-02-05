SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditAdviserReallocateClientDetails]
	@StampUser varchar (255),
	@AdviserReallocateClientDetailsId bigint,
	@StampAction char(1)
AS

INSERT INTO TAdviserReallocateClientDetailsAudit 
( AdviserReallocateStatsId, ClientPartyId, IsRelatedClient, IsProcessed, ErrorMessage,
		ConcurrencyId, AdviserReallocateClientDetailsId, StampAction, StampDateTime, StampUser) 
Select  AdviserReallocateStatsId, ClientPartyId, IsRelatedClient, IsProcessed, ErrorMessage,
		ConcurrencyId, AdviserReallocateClientDetailsId, @StampAction, GetDate(), @StampUser
FROM TAdviserReallocateClientDetails
WHERE AdviserReallocateClientDetailsId = @AdviserReallocateClientDetailsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
