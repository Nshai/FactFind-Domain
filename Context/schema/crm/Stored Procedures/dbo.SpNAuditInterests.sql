SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditInterests]
	@StampUser varchar (255),
	@InterestsId bigint,
	@StampAction char(1)
AS

INSERT INTO TInterestsAudit 
( CRMContactId, RefInterestId, ConcurrencyId, 
	InterestsId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, RefInterestId, ConcurrencyId, 
	InterestsId, @StampAction, GetDate(), @StampUser
FROM TInterests
WHERE InterestsId = @InterestsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
