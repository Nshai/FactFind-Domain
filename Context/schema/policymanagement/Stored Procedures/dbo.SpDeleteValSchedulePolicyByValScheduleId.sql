SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpDeleteValSchedulePolicyByValScheduleId]
@ValScheduleId bigint,
@StampUser varchar (255)
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
  INSERT INTO TValSchedulePolicyAudit (
    ValScheduleId, 
    PolicyBusinessId, 
    ClientCRMContactId, 
    UserCredentialOption, 
    PortalCRMContactId, 
    ConcurrencyId,
    ValSchedulePolicyId,
    StampAction,
    StampDateTime,
    StampUser)
  SELECT
    T1.ValScheduleId, 
    T1.PolicyBusinessId, 
    T1.ClientCRMContactId, 
    T1.UserCredentialOption, 
    T1.PortalCRMContactId, 
    T1.ConcurrencyId,
    T1.ValSchedulePolicyId,
    'D',
    GetDate(),
    @StampUser

  FROM TValSchedulePolicy T1

  WHERE (T1.ValScheduleId = @ValScheduleId)
  DELETE T1 FROM TValSchedulePolicy T1

  WHERE (T1.ValScheduleId = @ValScheduleId)


  SELECT 'deleted' = @@ROWCOUNT FOR XML RAW

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
