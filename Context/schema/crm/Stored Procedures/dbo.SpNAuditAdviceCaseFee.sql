SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAdviceCaseFee]
	@StampUser varchar (255),
	@AdviceCaseFeeId bigint,
	@StampAction char(1)
AS

INSERT INTO TAdviceCaseFeeAudit 
( AdviceCaseId, FeeId, ConcurrencyId, 
	AdviceCaseFeeId, StampAction, StampDateTime, StampUser) 
Select AdviceCaseId, FeeId, ConcurrencyId, 
	AdviceCaseFeeId, @StampAction, GetDate(), @StampUser
FROM TAdviceCaseFee
WHERE AdviceCaseFeeId = @AdviceCaseFeeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
