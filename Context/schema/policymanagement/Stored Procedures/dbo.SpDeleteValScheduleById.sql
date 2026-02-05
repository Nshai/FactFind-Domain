SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpDeleteValScheduleById]
	@ValScheduleId Bigint,
	@StampUser varchar (255)
	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	
	INSERT INTO TValScheduleAudit (
		Guid, 
		ScheduledLevel, 
		IndigoClientId, 
		RefProdProviderId, 
		ClientCRMContactId, 
		UserCredentialOption, 
		PortalCRMContactId, 
		StartDate, 
		Frequency, 
		IsLocked, 
		UserNameForFileAccess, 
		PasswordForFileAccess, 
		ConcurrencyId,
		ValScheduleId,
		StampAction,
    		StampDateTime,
    		StampUser)
		
	SELECT 
		T1.Guid, 
		T1.ScheduledLevel, 
		T1.IndigoClientId, 
		T1.RefProdProviderId, 
		T1.ClientCRMContactId, 
		T1.UserCredentialOption, 
		T1.PortalCRMContactId, 
		T1.StartDate, 
		T1.Frequency, 
		T1.IsLocked, 
		T1.UserNameForFileAccess, 
		T1.PasswordForFileAccess, 
		T1.ConcurrencyId,
		T1.ValScheduleId,
		'D',
    		GetDate(),
    		@StampUser 
	FROM TValSchedule T1	
	WHERE T1.ValScheduleId = @ValScheduleId

	DELETE T1 FROM TValSchedule T1
	WHERE T1.ValScheduleId = @ValScheduleId

	SELECT 'deleted' = @@ROWCOUNT FOR XML RAW

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
