SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditExternalApplicationOrganiserActivity]
	@StampUser varchar (255),
	@ExternalApplicationOrganiserActivityId bigint,
	@StampAction char(1)
AS

INSERT INTO TExternalApplicationOrganiserActivityAudit 
(ExternalApplicationOrganiserActivityId, TenantId, UserId, OrganiserActivityId, AppointmentId, CreatedDateTime, LastUpdatedDateTime, LastSynchronisedDateTime,
ExternalReference, InternalReference, IsForNewSync, IsForUpdateSync, IsForDeleteSync, IsDeleted, StampAction, StampDateTime, StampUser, SessionId, RetryCount) 
Select ExternalApplicationOrganiserActivityId, TenantId, UserId, OrganiserActivityId, AppointmentId, CreatedDateTime, LastUpdatedDateTime, LastSynchronisedDateTime,
ExternalReference, InternalReference, IsForNewSync, IsForUpdateSync, IsForDeleteSync, IsDeleted, @StampAction, GetDate(), @StampUser, SessionId, RetryCount
FROM TExternalApplicationOrganiserActivity
WHERE ExternalApplicationOrganiserActivityId = @ExternalApplicationOrganiserActivityId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO