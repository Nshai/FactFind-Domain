SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditActivityCategory2ActivityOutcome]
	@StampUser varchar (255),
	@ActivityCategory2ActivityOutcomeId bigint,
	@StampAction char(1)
AS

INSERT INTO TActivityCategory2ActivityOutcomeAudit 
( ActivityCategoryId, ActivityOutcomeId, ConcurrencyId, 
	ActivityCategory2ActivityOutcomeId, StampAction, StampDateTime, StampUser) 
Select ActivityCategoryId, ActivityOutcomeId, ConcurrencyId, 
	ActivityCategory2ActivityOutcomeId, @StampAction, GetDate(), @StampUser
FROM TActivityCategory2ActivityOutcome
WHERE ActivityCategory2ActivityOutcomeId = @ActivityCategory2ActivityOutcomeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
