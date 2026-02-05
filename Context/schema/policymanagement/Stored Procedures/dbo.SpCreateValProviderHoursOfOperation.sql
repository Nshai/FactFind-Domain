SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateValProviderHoursOfOperation]
	@StampUser varchar (255),
	@RefProdProviderId bigint, 
	@AlwaysAvailableFg bit, 
	@DayOfTheWeek varchar(20)  = NULL, 
	@StartHour tinyint = 0, 
	@EndHour tinyint = 0, 
	@StartMinute tinyint = 0, 
	@EndMinute tinyint = 0	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	
	DECLARE @ValProviderHoursOfOperationId bigint
			
	
	INSERT INTO TValProviderHoursOfOperation (
		RefProdProviderId, 
		AlwaysAvailableFg, 
		DayOfTheWeek, 
		StartHour, 
		EndHour, 
		StartMinute, 
		EndMinute, 
		ConcurrencyId)
		
	VALUES(
		@RefProdProviderId, 
		@AlwaysAvailableFg, 
		@DayOfTheWeek, 
		@StartHour, 
		@EndHour, 
		@StartMinute, 
		@EndMinute,
		1)

	SELECT @ValProviderHoursOfOperationId = SCOPE_IDENTITY()
	
	INSERT INTO TValProviderHoursOfOperationAudit (
		RefProdProviderId, 
		AlwaysAvailableFg, 
		DayOfTheWeek, 
		StartHour, 
		EndHour, 
		StartMinute, 
		EndMinute, 
		ConcurrencyId,
		ValProviderHoursOfOperationId,
		StampAction,
    	StampDateTime,
    	StampUser)
	SELECT  
		RefProdProviderId, 
		AlwaysAvailableFg, 
		DayOfTheWeek, 
		StartHour, 
		EndHour, 
		StartMinute, 
		EndMinute, 
		ConcurrencyId,
		ValProviderHoursOfOperationId,
		'C',
    	GetDate(),
    	@StampUser
	FROM TValProviderHoursOfOperation
	WHERE ValProviderHoursOfOperationId = @ValProviderHoursOfOperationId
	EXEC SpRetrieveValProviderHoursOfOperationById @ValProviderHoursOfOperationId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
