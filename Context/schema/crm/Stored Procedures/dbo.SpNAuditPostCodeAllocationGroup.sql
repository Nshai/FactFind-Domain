SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[SpNAuditPostCodeAllocationGroup]
	@StampUser varchar (255),
	@PostCodeAllocationGroupId bigint,
	@StampAction char(1)
AS

INSERT INTO TPostCodeAllocationGroupAudit 
( IndigoClientId, AllocationGroupName,  ConcurrencyId,PostCodeAllocationGroupId, StampAction, StampDateTime, StampUser) 
Select IndigoClientId, AllocationGroupName,  ConcurrencyId,PostCodeAllocationGroupId, @StampAction, GetDate(), @StampUser
FROM TPostCodeAllocationGroup
WHERE PostCodeAllocationGroupId = @PostCodeAllocationGroupId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)




GO
