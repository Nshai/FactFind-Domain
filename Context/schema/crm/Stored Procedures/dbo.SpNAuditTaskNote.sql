SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditTaskNote]
	@StampUser varchar (255),
	@TaskNoteId bigint,
	@StampAction char(1),
	@TaskId int
AS
BEGIN
	INSERT INTO dbo.TTaskNoteAudit ( 
		[CreatedBy], [CreatedDate], [EditedBy], [LastEdited], [Notes], [TaskId], [ConcurrencyId],
		[TaskNoteId], [StampAction], [StampDateTime], [StampUser],[IsAvailableToPfpClient]	
		) 
	SELECT
		[CreatedBy], [CreatedDate], [EditedBy], [LastEdited], [Notes], [TaskId], [ConcurrencyId],
		[TaskNoteId], @StampAction, GetDate(), @StampUser,[IsAvailableToPfpClient]
	FROM dbo.TTaskNote
	WHERE TaskNoteId = @TaskNoteId AND TaskId = @TaskId
END

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
