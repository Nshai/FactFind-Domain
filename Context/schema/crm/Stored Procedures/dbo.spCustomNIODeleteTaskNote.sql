set quoted_identifier on
go
set ansi_nulls on
go
create procedure [dbo].[spCustomNIODeleteTaskNote]
	@TaskNoteId int,
	@TaskId int,
	@UserId int
as

set nocount on

declare @StampDateTime datetime = getutcdate()

begin

	 delete note
		output DELETED.[CreatedBy], DELETED.[CreatedDate], DELETED.[LastEdited], DELETED.[Notes], DELETED.[TaskId],
			DELETED.[ConcurrencyId], DELETED.[TaskNoteId], 'D', @StampDateTime, @UserId, DELETED.[EditedBy],
			DELETED.[IsAvailableToPfpClient], DELETED.[MigrationRef]
		into [dbo].[TTaskNoteAudit]
			([CreatedBy], [CreatedDate], [LastEdited], [Notes], [TaskId],
			[ConcurrencyId], [TaskNoteId], [StampAction], [StampDateTime], [StampUser], [EditedBy],
			[IsAvailableToPfpClient], [MigrationRef])
	from TTaskNote note
	where note.TaskNoteId = @TaskNoteId and note.TaskId = @TaskId

end
return (0)

go
