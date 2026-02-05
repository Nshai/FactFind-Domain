SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateContact]
@StampUser varchar (255),
@IndClientId bigint,
@CRMContactId bigint,
@RefContactType varchar (50),
@Description varchar (8000) = NULL,
@Value varchar (255),
@DefaultFg tinyint
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @ContactId bigint

  INSERT INTO TContact (
    IndClientId, 
    CRMContactId, 
    RefContactType, 
    Description, 
    Value, 
    DefaultFg, 
    ConcurrencyId ) 
  VALUES (
    @IndClientId, 
    @CRMContactId, 
    @RefContactType, 
    @Description, 
    @Value, 
    @DefaultFg, 
    1) 

  SELECT @ContactId = SCOPE_IDENTITY()
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
    'C',
    GetDate(),
    @StampUser

  FROM TContact T1
 WHERE T1.ContactId=@ContactId
  EXEC SpRetrieveContactById @ContactId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
