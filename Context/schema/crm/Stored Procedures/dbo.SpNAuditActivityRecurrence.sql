SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditActivityRecurrence]
	@StampUser varchar (255),
	@ActivityRecurrenceId bigint,
	@StampAction char(1)
AS
BEGIN
	INSERT INTO dbo.TActivityRecurrenceAudit ( 
		[RFCCode], [StartDate], [EndDate], [OrganiserActivityId], [ConcurrencyId],
		[ActivityRecurrenceId], [StampAction], [StampDateTime], [StampUser]	
		) 
	SELECT
		[RFCCode], [StartDate], [EndDate], [OrganiserActivityId], [ConcurrencyId],
		[ActivityRecurrenceId], @StampAction, GetDate(), @StampUser
	FROM dbo.[TActivityRecurrence]
	WHERE ActivityRecurrenceId = @ActivityRecurrenceId
END

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
