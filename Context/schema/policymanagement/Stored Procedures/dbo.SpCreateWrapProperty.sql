SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateWrapProperty]
	@StampUser varchar (255),
	@IndigoClientId bigint, 
	@WrapperProviderId bigint, 
	@AddWrapPlanFromValuation tinyint = NULL, 
	@AddPlanAsPreExisting tinyint = NULL, 
	@AdviceTypeId bigint	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	
	DECLARE @WrapPropertyId bigint
			
	
	INSERT INTO TWrapProperty (
		IndigoClientId, 
		WrapperProviderId, 
		AddWrapPlanFromValuation, 
		AddPlanAsPreExisting, 
		AdviceTypeId, 
		ConcurrencyId)
		
	VALUES(
		@IndigoClientId, 
		@WrapperProviderId, 
		@AddWrapPlanFromValuation, 
		@AddPlanAsPreExisting, 
		@AdviceTypeId,
		1)

	SELECT @WrapPropertyId = SCOPE_IDENTITY()
	
	INSERT INTO TWrapPropertyAudit (
		IndigoClientId, 
		WrapperProviderId, 
		AddWrapPlanFromValuation, 
		AddPlanAsPreExisting, 
		AdviceTypeId, 
		ConcurrencyId,
		WrapPropertyId,
		StampAction,
    	StampDateTime,
    	StampUser)
	SELECT  
		IndigoClientId, 
		WrapperProviderId, 
		AddWrapPlanFromValuation, 
		AddPlanAsPreExisting, 
		AdviceTypeId, 
		ConcurrencyId,
		WrapPropertyId,
		'C',
    	GetDate(),
    	@StampUser
	FROM TWrapProperty
	WHERE WrapPropertyId = @WrapPropertyId
	EXEC SpRetrieveWrapPropertyById @WrapPropertyId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
