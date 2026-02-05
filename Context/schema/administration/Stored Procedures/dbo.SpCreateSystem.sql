SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateSystem]
@StampUser varchar (255),
@Identifier varchar (64),
@Description varchar (64) = NULL,
@SystemPath varchar (256) = NULL,
@SystemType varchar (16) = NULL,
@ParentId bigint = NULL,
@Url varchar (128) = NULL,
@EntityId bigint = NULL
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @SystemId bigint

  INSERT INTO TSystem (
    Identifier, 
    Description, 
    SystemPath, 
    SystemType, 
    ParentId, 
    Url, 
    EntityId, 
    ConcurrencyId ) 
  VALUES (
    @Identifier, 
    @Description, 
    @SystemPath, 
    @SystemType, 
    @ParentId, 
    @Url, 
    @EntityId, 
    1) 

  SELECT @SystemId = SCOPE_IDENTITY()
  INSERT INTO TSystemAudit (
    Identifier, 
    Description, 
    SystemPath, 
    SystemType, 
    ParentId, 
    Url, 
    EntityId, 
    ConcurrencyId,
    SystemId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.Identifier, 
    T1.Description, 
    T1.SystemPath, 
    T1.SystemType, 
    T1.ParentId, 
    T1.Url, 
    T1.EntityId, 
    T1.ConcurrencyId,
    T1.SystemId,
    'C',
    GetDate(),
    @StampUser

  FROM TSystem T1
 WHERE T1.SystemId=@SystemId
  EXEC SpRetrieveSystemById @SystemId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)





GO
