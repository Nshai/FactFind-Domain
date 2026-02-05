SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateStatusReason]
@StampUser varchar (255),
@Name varchar (50),
@StatusId bigint,
@OrigoStatusId bigint = NULL,
@IntelligentOfficeStatusType varchar (50) = NULL,
@IndigoClientId bigint
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @StatusReasonId bigint

  INSERT INTO TStatusReason (
    Name, 
    StatusId, 
    OrigoStatusId, 
    IntelligentOfficeStatusType, 
    IndigoClientId, 
    ConcurrencyId ) 
  VALUES (
    @Name, 
    @StatusId, 
    @OrigoStatusId, 
    @IntelligentOfficeStatusType, 
    @IndigoClientId, 
    1) 

  SELECT @StatusReasonId = SCOPE_IDENTITY()
  INSERT INTO TStatusReasonAudit (
    Name, 
    StatusId, 
    OrigoStatusId, 
    IntelligentOfficeStatusType, 
    IndigoClientId, 
    ConcurrencyId,
    StatusReasonId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.Name, 
    T1.StatusId, 
    T1.OrigoStatusId, 
    T1.IntelligentOfficeStatusType, 
    T1.IndigoClientId, 
    T1.ConcurrencyId,
    T1.StatusReasonId,
    'C',
    GetDate(),
    @StampUser

  FROM TStatusReason T1
 WHERE T1.StatusReasonId=@StatusReasonId
  EXEC SpRetrieveStatusReasonById @StatusReasonId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)



GO
