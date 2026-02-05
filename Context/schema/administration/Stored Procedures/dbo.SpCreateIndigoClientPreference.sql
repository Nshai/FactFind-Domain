SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateIndigoClientPreference]
	@StampUser varchar (255),
	@IndigoClientId bigint, 
	@IndigoClientGuid varchar(255) , 
	@PreferenceName varchar(255) , 
	@Value varchar(255)  = NULL, 
	@Disabled bit = 0	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	
	DECLARE @IndigoClientPreferenceId bigint
			
	
	INSERT INTO TIndigoClientPreference (
		IndigoClientId, 
		IndigoClientGuid, 
		PreferenceName, 
		Value, 
		Disabled, 
		ConcurrencyId)
		
	VALUES(
		@IndigoClientId, 
		@IndigoClientGuid, 
		@PreferenceName, 
		@Value, 
		@Disabled,
		1)

	SELECT @IndigoClientPreferenceId = SCOPE_IDENTITY()
	
	INSERT INTO TIndigoClientPreferenceAudit (
		IndigoClientId, 
		IndigoClientGuid, 
		PreferenceName, 
		Value, 
		Disabled, 
		ConcurrencyId,
		IndigoClientPreferenceId,
		StampAction,
    	StampDateTime,
    	StampUser)
	SELECT  
		IndigoClientId, 
		IndigoClientGuid, 
		PreferenceName, 
		Value, 
		Disabled, 
		ConcurrencyId,
		IndigoClientPreferenceId,
		'C',
    	GetDate(),
    	@StampUser
	FROM TIndigoClientPreference
	WHERE IndigoClientPreferenceId = @IndigoClientPreferenceId
	EXEC SpRetrieveIndigoClientPreferenceById @IndigoClientPreferenceId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
