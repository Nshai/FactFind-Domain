SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateValScheduleConfig]
	@StampUser varchar (255),
	@RefProdProviderId bigint, 
	@ScheduleStartTime varchar(50)  = NULL, 
	@IsEnabled bit = 1	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	
	DECLARE @ValScheduleConfigId bigint
			
	
	INSERT INTO TValScheduleConfig (
		RefProdProviderId, 
		ScheduleStartTime, 
		IsEnabled, 
		ConcurrencyId)
		
	VALUES(
		@RefProdProviderId, 
		@ScheduleStartTime, 
		@IsEnabled,
		1)

	SELECT @ValScheduleConfigId = SCOPE_IDENTITY()
	
	INSERT INTO TValScheduleConfigAudit (
		RefProdProviderId, 
		ScheduleStartTime, 
		IsEnabled, 
		ConcurrencyId,
		ValScheduleConfigId,
		StampAction,
    	StampDateTime,
    	StampUser)
	SELECT  
		RefProdProviderId, 
		ScheduleStartTime, 
		IsEnabled, 
		ConcurrencyId,
		ValScheduleConfigId,
		'C',
    	GetDate(),
    	@StampUser
	FROM TValScheduleConfig
	WHERE ValScheduleConfigId = @ValScheduleConfigId
	EXEC SpRetrieveValScheduleConfigById @ValScheduleConfigId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)

GO
