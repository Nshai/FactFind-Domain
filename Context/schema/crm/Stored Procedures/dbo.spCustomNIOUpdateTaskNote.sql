set quoted_identifier on
go
set ansi_nulls on
go
create procedure [dbo].[spCustomNIOUpdateTaskNote]
	@TaskNoteId int,
	@TaskId int,
	@UserId int,
	@Note varchar(max)
as

set nocount on

declare @StampDateTime datetime = getutcdate()
declare @crmcontactid int

begin

	select @crmcontactid = crmcontactid from administration..TUser with (nolock) where userid = @UserId

	 update note
	 set Notes = @Note, LastEdited =  @StampDateTime, EditedBy = @crmcontactid, ConcurrencyId = ConcurrencyId + 1
		output DELETED.[CreatedBy], DELETED.[CreatedDate], DELETED.[LastEdited], DELETED.[Notes], DELETED.[TaskId],
			DELETED.[ConcurrencyId], DELETED.[TaskNoteId], 'U', @StampDateTime, @UserId, DELETED.[EditedBy],
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
