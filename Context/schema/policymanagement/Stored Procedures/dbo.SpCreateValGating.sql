SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateValGating]
	@StampUser varchar (255),
	@RefProdProviderId bigint, 
	@RefPlanTypeId bigint, 
	@ProdSubTypeId bigint = NULL, 
	@OrigoProductType varchar(255)  = NULL, 
	@OrigoProductVersion varchar(255)  = NULL, 
	@ValuationXSLId bigint = NULL, 
	@ProviderPlanTypeName varchar(255)  = NULL	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	
	DECLARE @ValGatingId bigint
			
	
	INSERT INTO TValGating (
		RefProdProviderId, 
		RefPlanTypeId, 
		ProdSubTypeId, 
		OrigoProductType, 
		OrigoProductVersion, 
		ValuationXSLId, 
		ProviderPlanTypeName, 
		ConcurrencyId)
		
	VALUES(
		@RefProdProviderId, 
		@RefPlanTypeId, 
		@ProdSubTypeId, 
		@OrigoProductType, 
		@OrigoProductVersion, 
		@ValuationXSLId, 
		@ProviderPlanTypeName,
		1)

	SELECT @ValGatingId = SCOPE_IDENTITY()
	
	INSERT INTO TValGatingAudit (
		RefProdProviderId, 
		RefPlanTypeId, 
		ProdSubTypeId, 
		OrigoProductType, 
		OrigoProductVersion, 
		ValuationXSLId, 
		ProviderPlanTypeName, 
		ConcurrencyId,
		ValGatingId,
		StampAction,
	    	StampDateTime,
    		StampUser)
	SELECT  
		RefProdProviderId, 
		RefPlanTypeId, 
		ProdSubTypeId, 
		OrigoProductType, 
		OrigoProductVersion, 
		ValuationXSLId, 
		ProviderPlanTypeName, 
		ConcurrencyId,
		ValGatingId,
		'C',
	    	GetDate(),
    		@StampUser
	FROM TValGating
	WHERE ValGatingId = @ValGatingId
	EXEC SpRetrieveValGatingById @ValGatingId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
