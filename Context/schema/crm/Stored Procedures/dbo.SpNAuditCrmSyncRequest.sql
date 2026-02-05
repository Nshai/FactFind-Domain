SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditCrmSyncRequest]
	@StampUser varchar (255),
	@CrmSyncRequestId uniqueidentifier,
	@StampAction char(1)
AS

INSERT INTO TCrmSyncRequestAudit(
	CrmSyncRequestId, ClientPartyId, CreatedByUserId, RefApplicationId, SyncCrmAction, SyncCrmStatus,
	Retries, CreatedDateTime, LastUpdatedDateTime, IndigoClientId, ConcurrencyId, STAMPACTION, STAMPDATETIME, STAMPUSER)

SELECT  
	CrmSyncRequestId, ClientPartyId, CreatedByUserId, RefApplicationId, SyncCrmAction, SyncCrmStatus,
	Retries, CreatedDateTime, LastUpdatedDateTime, IndigoClientId, ConcurrencyId, @StampAction, GetDate(), @StampUser
FROM 
	TCrmSyncRequest
WHERE CrmSyncRequestId = @CrmSyncRequestId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO