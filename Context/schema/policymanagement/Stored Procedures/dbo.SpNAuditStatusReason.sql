SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditStatusReason]
	@StampUser varchar (255),
	@StatusReasonId bigint,
	@StampAction char(1)
AS

INSERT INTO TStatusReasonAudit 
( Name, StatusId, OrigoStatusId, IntelligentOfficeStatusType, 
		IndigoClientId, ConcurrencyId, 
	StatusReasonId, StampAction, StampDateTime, StampUser) 
Select Name, StatusId, OrigoStatusId, IntelligentOfficeStatusType, 
		IndigoClientId, ConcurrencyId, 
	StatusReasonId, @StampAction, GetDate(), @StampUser
FROM TStatusReason
WHERE StatusReasonId = @StatusReasonId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
