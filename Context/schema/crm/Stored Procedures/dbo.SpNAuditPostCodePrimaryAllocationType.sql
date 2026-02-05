SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditPostCodePrimaryAllocationType]
	@StampUser varchar (255),
	@PrimaryAllocationTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TPostCodePrimaryAllocationTypeAudit 
( PrimaryAllocationTypeName,  ConcurrencyId,PrimaryAllocationTypeId, StampAction, StampDateTime, StampUser) 
Select PrimaryAllocationTypeName,  ConcurrencyId,PrimaryAllocationTypeId, @StampAction, GetDate(), @StampUser
FROM TPostCodePrimaryAllocationType
WHERE PrimaryAllocationTypeId = @PrimaryAllocationTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
