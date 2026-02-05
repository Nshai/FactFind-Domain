SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditClientShareNote]
	@StampUser varchar (255),
	@ClientShareNoteId bigint,
	@StampAction char(1)
AS

INSERT INTO TClientShareNoteAudit 
	( 
		[ClientShareNoteId], [Notes], [CreatedBy], [CreatedDate], [LastEditedBy], 
		[LastEditedDate], [ClientShareId], [TenantId], [ConcurrencyId], 
		StampAction, StampDateTime, StampUser
		) 
Select [ClientShareNoteId], [Notes], [CreatedBy], [CreatedDate], [LastEditedBy], 
		[LastEditedDate], [ClientShareId], [TenantId], [ConcurrencyId],
		@StampAction, GetDate(), @StampUser
FROM TClientShareNote
WHERE ClientShareNoteId = @ClientShareNoteId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
