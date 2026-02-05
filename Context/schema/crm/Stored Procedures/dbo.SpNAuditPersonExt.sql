SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditPersonExt]
	@StampUser varchar (255),
	@PersonExtId bigint,
	@StampAction char(1)
AS

INSERT INTO TPersonExtAudit ( 
	PersonExtId, PersonId, HealthNotes, MedicalConditionNotes, HasOtherConsiderations, OtherConsiderationsNotes, StampAction, StampDateTime, StampUser) 
SELECT
	PersonExtId, PersonId, HealthNotes, MedicalConditionNotes, HasOtherConsiderations, OtherConsiderationsNotes, @StampAction, GETDATE(), @StampUser
FROM 
	TPersonExt
WHERE
	PersonExtId = @PersonExtId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
