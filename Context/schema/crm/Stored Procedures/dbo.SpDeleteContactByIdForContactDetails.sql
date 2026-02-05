SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpDeleteContactByIdForContactDetails]
@ContactId bigint,
@StampUser varchar (255)
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  INSERT INTO TContactAudit (
    IndClientId, 
    CRMContactId, 
    RefContactType, 
    Description, 
    Value, 
    DefaultFg, 
    ConcurrencyId,
    ContactId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.IndClientId, 
    T1.CRMContactId, 
    T1.RefContactType, 
    T1.Description, 
    T1.Value, 
    T1.DefaultFg, 
    T1.ConcurrencyId,
    T1.ContactId,
    'D',
    GetDate(),
    @StampUser

  FROM TContact T1

  WHERE T1.ContactId = @ContactId 
  DELETE T1 FROM TContact T1

  WHERE T1.ContactId = @ContactId

  SELECT 'deleted' = @@ROWCOUNT FOR XML RAW

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)








GO
