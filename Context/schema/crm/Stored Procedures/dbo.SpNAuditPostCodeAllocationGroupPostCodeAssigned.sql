SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[SpNAuditPostCodeAllocationGroupPostCodeAssigned]
	@StampUser varchar (255),
	@PostCodeAllocationGroupPostCodeAssignedId bigint,
	@StampAction char(1)
AS

INSERT INTO TPostCodeAllocationGroupPostCodeAssignedAudit 
( PostCodeAllocationGroupId,PostCodeId,  ConcurrencyId,PostCodeAllocationGroupPostCodeAssignedId
, StampAction, StampDateTime, StampUser) 
Select PostCodeAllocationGroupId,PostCodeId,  ConcurrencyId,PostCodeAllocationGroupPostCodeAssignedId
, @StampAction, GetDate(), @StampUser
FROM TPostCodeAllocationGroupPostCodeAssigned
WHERE PostCodeAllocationGroupPostCodeAssignedId = @PostCodeAllocationGroupPostCodeAssignedId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)




GO
