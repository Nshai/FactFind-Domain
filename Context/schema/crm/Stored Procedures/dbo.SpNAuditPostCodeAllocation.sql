SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditPostCodeAllocation]
	@StampUser varchar (255),
	@PostCodeAllocationId bigint,
	@StampAction char(1)
AS

INSERT INTO TPostCodeAllocationAudit 
( IndigoClientId,AllocationTypeId, MaxDistance,SecondaryAllocationTypeId,CanAssignPostCodeMoreThanOne,CanAssignAdviserMoreThanOne,  ConcurrencyId,PostCodeAllocationId, StampAction, StampDateTime, StampUser) 
Select IndigoClientId, AllocationTypeId, MaxDistance, SecondaryAllocationTypeId,CanAssignPostCodeMoreThanOne,CanAssignAdviserMoreThanOne,ConcurrencyId,PostCodeAllocationId, @StampAction, GetDate(), @StampUser
FROM TPostCodeAllocation
WHERE PostCodeAllocationId = @PostCodeAllocationId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
