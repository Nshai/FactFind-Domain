SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateAssetCategoryForNewClients]
@IndigoClientId bigint
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	EXEC SpCreateAssetCategory 0, 'Main Residence',	'Property', @IndigoClientId
	EXEC SpCreateAssetCategory 0, 'Home Contents', 'Home Contents', @IndigoClientId
	EXEC SpCreateAssetCategory 0, 'Motor Vehicles', 'Motor Vehicles', @IndigoClientId
	EXEC SpCreateAssetCategory 0, 'Rental Property/Other Property', 'Property', @IndigoClientId
	EXEC SpCreateAssetCategory 0, 'Non-Income Producing Real Estate', 'Non-Income Producing Real Estate', @IndigoClientId
	EXEC SpCreateAssetCategory 0, 'Collectibles/Art/Other Valuables', 'Collectibles/Art/Other Valuables', @IndigoClientId
	EXEC SpCreateAssetCategory 0, 'Own Business', 'Own Business', @IndigoClientId
	EXEC SpCreateAssetCategory 0, 'Cash', 'Cash', @IndigoClientId
IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX
END
RETURN (0)
errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
