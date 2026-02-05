SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditActivityOutcome]
	@StampUser varchar (255),
	@ActivityOutcomeId bigint,
	@StampAction char(1)
AS

INSERT INTO TActivityOutcomeAudit 
( ActivityOutcomeName, IndigoClientId, ArchiveFG, ConcurrencyId, 
		
	ActivityOutcomeId, StampAction, StampDateTime, StampUser, GroupId) 
Select ActivityOutcomeName, IndigoClientId, ArchiveFG, ConcurrencyId, 
		
	ActivityOutcomeId, @StampAction, GetDate(), @StampUser, GroupId
FROM TActivityOutcome
WHERE ActivityOutcomeId = @ActivityOutcomeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
