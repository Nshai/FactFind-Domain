SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditClientServiceHistory]
	@StampUser varchar (255),
	@ClientServiceHistoryId bigint,
	@StampAction char(1)
AS

INSERT INTO TClientServiceHistoryAudit 
	( CRMContactId, ChangeType, ServiceStatusIdFrom, ServiceStatusIdTo, 
	FeeModelIdFrom, FeeModelIdTo, AdviserIdFrom, AdviserIdTo, 
	ChangedByUserId, ChangeDate, ServiceStatusStartDate, 
	ClientServiceHistoryId, StampAction, StampDateTime, StampUser, 
	RelationshipFrom, RelationshipTo, FromUserId, ToUserId, VulnerabilityFromId, 
	VulnerabilityToId, ClientSegmentIdFrom, ClientSegmentIdTo, ClientSegmentStartDate) 
SELECT CRMContactId, ChangeType, ServiceStatusIdFrom, ServiceStatusIdTo, 
	FeeModelIdFrom, FeeModelIdTo, AdviserIdFrom, AdviserIdTo, 
	ChangedByUserId, ChangeDate, ServiceStatusStartDate, 
	ClientServiceHistoryId, @StampAction, GetDate(), @StampUser, RelationshipFrom, 
	RelationshipTo, FromUserId,ToUserId, VulnerabilityFromId, VulnerabilityToId,
	ClientSegmentIdFrom, ClientSegmentIdTo, ClientSegmentStartDate

FROM TClientServiceHistory
WHERE ClientServiceHistoryId = @ClientServiceHistoryId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO


