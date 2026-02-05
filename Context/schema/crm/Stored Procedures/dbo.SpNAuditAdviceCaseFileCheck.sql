SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAdviceCaseFileCheck]
	@StampUser varchar (255),
	@AdviceCaseFileCheckId bigint,
	@StampAction char(1)
AS

INSERT INTO TAdviceCaseFileCheckAudit 
( AdviceCaseId, FileCheckMiniId, ConcurrencyId, 
	AdviceCaseFileCheckId, StampAction, StampDateTime, StampUser) 
Select AdviceCaseId, FileCheckMiniId, ConcurrencyId, 
	AdviceCaseFileCheckId, @StampAction, GetDate(), @StampUser
FROM TAdviceCaseFileCheck
WHERE AdviceCaseFileCheckId = @AdviceCaseFileCheckId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
