SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditCrmSyncResponse]
	@StampUser varchar (255),
	@CrmSyncResponseId bigint,
	@StampAction char(1)
AS

INSERT INTO TCrmSyncResponseAudit(
	CrmSyncResponseId, CrmSyncRequestId, RetryNumber, RequestString, SystemError,
	ResponseString, ErrorMessage, ConcurrencyId, STAMPACTION, STAMPDATETIME, STAMPUSER)
	
SELECT  
	CrmSyncResponseId, CrmSyncRequestId, RetryNumber, RequestString, SystemError,
	ResponseString, ErrorMessage, ConcurrencyId, @StampAction, GetDate(), @StampUser
FROM 
	TCrmSyncResponse
WHERE CrmSyncResponseId = @CrmSyncResponseId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO