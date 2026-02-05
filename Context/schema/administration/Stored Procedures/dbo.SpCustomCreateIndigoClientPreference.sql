SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomCreateIndigoClientPreference]
	@StampUser varchar (255),
	@IndigoClientId bigint, 
	@IndigoClientGuid varchar(255) , 
	@PreferenceName varchar(255) , 
	@Value varchar(255)  = NULL, 
	@Disabled bit = 0	
AS

SET NOCOUNT ON

--DO NOT INSERT IF IT ALREADY EXISTS
   IF EXISTS ( SELECT IndigoClientPreferenceId FROM TIndigoClientPreference
				WHERE PreferenceName = @PreferenceName AND Value=@Value AND IndigoClientId = @IndigoClientId  )
   RETURN 0
   
DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	
	DECLARE @IndigoClientPreferenceId varchar(255)		
	
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



	INSERT INTO TIndigoClientPreferenceCombined (
		Guid,
		IndigoClientPreferenceId, 
		IndigoClientId, 
		IndigoClientGuid, 
		PreferenceName, 
		Value, 
		Disabled, 
		ConcurrencyId)
	SELECT  
		Guid,
		IndigoClientPreferenceId,
		IndigoClientId, 
		IndigoClientGuid, 
		PreferenceName, 
		Value, 
		Disabled, 
		ConcurrencyId

	FROM TIndigoClientPreference
	WHERE IndigoClientPreferenceId = @IndigoClientPreferenceId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
