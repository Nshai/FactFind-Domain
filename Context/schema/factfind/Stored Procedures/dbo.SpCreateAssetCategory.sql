SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateAssetCategory]
	@StampUser varchar (255),
	@CategoryName varchar(50) , 
	@SectorName varchar(50) , 
	@IndigoClientId bigint = NULL	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	
	DECLARE @AssetCategoryId bigint
			
	
	INSERT INTO TAssetCategory (
		CategoryName, 
		SectorName, 
		IndigoClientId, 
		ConcurrencyId)
		
	VALUES(
		@CategoryName, 
		@SectorName, 
		@IndigoClientId,
		1)

	SELECT @AssetCategoryId = SCOPE_IDENTITY()

	INSERT INTO TAssetCategoryAudit (
		CategoryName, 
		SectorName, 
		IndigoClientId, 
		ConcurrencyId,
		AssetCategoryId,
		StampAction,
    	StampDateTime,
    	StampUser)
	SELECT  
		CategoryName, 
		SectorName, 
		IndigoClientId, 
		ConcurrencyId,
		AssetCategoryId,
		'C',
    	GetDate(),
    	@StampUser
	FROM TAssetCategory
	WHERE AssetCategoryId = @AssetCategoryId

	EXEC SpRetrieveAssetCategoryById @AssetCategoryId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
