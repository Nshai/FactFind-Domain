SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditFeeNote]
	@StampUser varchar (255),
	@FeeNoteId bigint,
	@StampAction char(1)
AS
BEGIN
	INSERT INTO dbo.TFeeNoteAudit ( 
		[CreatedBy], [CreatedDate], [UpdatedBy], [LastEdited], [Notes], [FeeId], [ConcurrencyId],
		[FeeNoteId], [StampAction], [StampDateTime], [StampUser]	
		) 
	SELECT
		[CreatedBy], [CreatedDate], [UpdatedBy], [LastEdited], [Notes], [FeeId], [ConcurrencyId],
		[FeeNoteId], @StampAction, GetDate(), @StampUser
	FROM dbo.TFeeNote
	WHERE FeeNoteId = @FeeNoteId
END

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
