SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpCreateStatus]
@StampUser varchar (255),
@Name varchar (50),
@OrigoStatusId bigint = NULL,
@IntelligentOfficeStatusType varchar (50) = NULL,
@PreComplianceCheck bit = 0,
@PostComplianceCheck bit = 0,
@IndigoClientId bigint
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  DECLARE @StatusId bigint

  INSERT INTO TStatus (
    Name, 
    OrigoStatusId, 
    IntelligentOfficeStatusType, 
    PreComplianceCheck, 
    PostComplianceCheck, 
    IndigoClientId, 
    ConcurrencyId ) 
  VALUES (
    @Name, 
    @OrigoStatusId, 
    @IntelligentOfficeStatusType, 
    @PreComplianceCheck, 
    @PostComplianceCheck, 
    @IndigoClientId, 
    1) 

  SELECT @StatusId = SCOPE_IDENTITY()
  INSERT INTO TStatusAudit (
    Name, 
    OrigoStatusId, 
    IntelligentOfficeStatusType, 
    PreComplianceCheck, 
    PostComplianceCheck, 
    IndigoClientId, 
    ConcurrencyId,
    StatusId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.Name, 
    T1.OrigoStatusId, 
    T1.IntelligentOfficeStatusType, 
    T1.PreComplianceCheck, 
    T1.PostComplianceCheck, 
    T1.IndigoClientId, 
    T1.ConcurrencyId,
    T1.StatusId,
    'C',
    GetDate(),
    @StampUser

  FROM TStatus T1
 WHERE T1.StatusId=@StatusId
  EXEC SpRetrieveStatusById @StatusId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)


GO
