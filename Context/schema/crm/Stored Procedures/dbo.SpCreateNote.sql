SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpCreateNote]
@StampUser varchar (255),
@EntityType varchar (255) = NULL,
@EntityId bigint = NULL,
@Notes text = NULL,
@LatestNote varchar (4000) = NULL
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @NoteId bigint

  INSERT INTO TNote (
    EntityType, 
    EntityId, 
    Notes, 
    LatestNote, 
    ConcurrencyId ) 
  VALUES (
    @EntityType, 
    @EntityId, 
    @Notes, 
    @LatestNote, 
    1) 

  SELECT @NoteId = SCOPE_IDENTITY()
  INSERT INTO TNoteAudit (
    EntityType, 
    EntityId, 
    Notes, 
    LatestNote, 
    ConcurrencyId,
    NoteId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.EntityType, 
    T1.EntityId, 
    T1.Notes, 
    T1.LatestNote, 
    T1.ConcurrencyId,
    T1.NoteId,
    'C',
    GetDate(),
    @StampUser

  FROM TNote T1
 WHERE T1.NoteId=@NoteId
  EXEC SpRetrieveNoteById @NoteId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
