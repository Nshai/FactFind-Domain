SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[SpNAuditPostCodeAllocationGroupAdviserAssigned]
	@StampUser varchar (255),
	@PostCodeAllocationGroupAdviserAssignedId bigint,
	@StampAction char(1)
AS

INSERT INTO TPostCodeAllocationGroupAdviserAssignedAudit 
( CRMContactId,PostCodeAllocationGroupId,  ConcurrencyId,PostCodeAllocationGroupAdviserAssignedId
, StampAction, StampDateTime, StampUser) 
Select CRMContactId,PostCodeAllocationGroupId,  ConcurrencyId,PostCodeAllocationGroupAdviserAssignedId
, @StampAction, GetDate(), @StampUser
FROM TPostCodeAllocationGroupAdviserAssigned
WHERE PostCodeAllocationGroupAdviserAssignedId = @PostCodeAllocationGroupAdviserAssignedId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)




GO
