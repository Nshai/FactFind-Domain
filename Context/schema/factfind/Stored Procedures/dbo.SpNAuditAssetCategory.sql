SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditAssetCategory]
	@StampUser varchar (255),
	@AssetCategoryId bigint,
	@StampAction char(1)
AS

INSERT INTO TAssetCategoryAudit 
( CategoryName, SectorName, IndigoClientId, ConcurrencyId, 
		
	AssetCategoryId, StampAction, StampDateTime, StampUser) 
Select CategoryName, SectorName, IndigoClientId, ConcurrencyId, 
		
	AssetCategoryId, @StampAction, GetDate(), @StampUser
FROM TAssetCategory
WHERE AssetCategoryId = @AssetCategoryId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
