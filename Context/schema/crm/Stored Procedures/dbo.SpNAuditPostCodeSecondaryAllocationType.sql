SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SpNAuditPostCodeSecondaryAllocationType]
	@StampUser varchar (255),
	@SecondaryAllocationTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO TPostCodeSecondaryAllocationTypeAudit 
(SecondaryAllocationTypeName,  ConcurrencyId,SecondaryAllocationTypeId, StampAction, StampDateTime, StampUser) 
Select SecondaryAllocationTypeName,  ConcurrencyId,SecondaryAllocationTypeId, @StampAction, GetDate(), @StampUser
FROM TPostCodeSecondaryAllocationType
WHERE SecondaryAllocationTypeId = @SecondaryAllocationTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)



GO
