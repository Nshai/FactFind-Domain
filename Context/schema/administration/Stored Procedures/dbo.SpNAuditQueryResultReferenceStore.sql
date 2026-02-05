SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditQueryResultReferenceStore]
	@StampUser varchar (255),
	@QueryResultReferenceStoreId bigint,
	@StampAction char(1)
AS

INSERT INTO TQueryResultReferenceStoreAudit 
( Reference, MIReportId, UserId, TenantId, 
		Data, CreatedTimeStamp, ConcurrencyId, 
	QueryResultReferenceStoreId, StampAction, StampDateTime, StampUser) 
Select Reference, MIReportId, UserId, TenantId, 
		Data, CreatedTimeStamp, ConcurrencyId, 
	QueryResultReferenceStoreId, @StampAction, GetDate(), @StampUser
FROM TQueryResultReferenceStore
WHERE QueryResultReferenceStoreId = @QueryResultReferenceStoreId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
