SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditValBulkRequest]
	@StampUser varchar (255),
	@ValBulkRequestId bigint,
	@StampAction char(1)
AS

INSERT INTO TValBulkRequestAudit
     ( [ValScheduleId]
           ,[TenantId]
           ,[RefProdProviderId]
           ,[Request]
           ,[RequestDate]
           ,[RequestType]
           ,[Response]
           ,[ThirdPartyRef]
           ,[ResponseDate]
           ,[StatusCode]
           ,[StatusDescription]
           ,[RequestGuid]
           ,[RequestedByUserId]
           ,[ConcurrencyId],[ValBulkRequestId]
		   ,[StampAction],[StampDateTime],[StampUser]) 
Select [ValScheduleId]
           ,[TenantId]
           ,[RefProdProviderId]
           ,[Request]
           ,[RequestDate]
           ,[RequestType]
           ,[Response]
           ,[ThirdPartyRef]
           ,[ResponseDate]
           ,[StatusCode]
           ,[StatusDescription]
           ,[RequestGuid]
           ,[RequestedByUserId]
           ,[ConcurrencyId], [ValBulkRequestId]
		   , @StampAction, GetDate(), @StampUser
FROM TValBulkRequest
WHERE ValBulkRequestId = @ValBulkRequestId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
