SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAdviceCaseStatus]
	@StampUser varchar (255),
	@AdviceCaseStatusId bigint,
	@StampAction char(1)
AS

INSERT INTO TAdviceCaseStatusAudit 
( TenantId, Descriptor, IsDefault, IsComplete, 
		ConcurrencyId, 
	AdviceCaseStatusId, StampAction, StampDateTime, StampUser) 
Select TenantId, Descriptor, IsDefault, IsComplete, 
		ConcurrencyId, 
	AdviceCaseStatusId, @StampAction, GetDate(), @StampUser
FROM TAdviceCaseStatus
WHERE AdviceCaseStatusId = @AdviceCaseStatusId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
