SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
create PROCEDURE [dbo].[SpNAuditBrandAsset]
	@StampUser varchar (255),
	@BrandAssetId int,
	@StampAction char(1)
AS

INSERT INTO [dbo].[TBrandAssetAudit]
           ([BrandAssetId]
           ,[BrandId]
           ,[Name]
           ,[Value]
           ,[MimeType]
           ,[TenantId]
           ,[StampAction]
           ,[StampDateTime]
           ,[StampUser])
Select		[BrandAssetId]
           ,[BrandId]
           ,[Name]
           ,[Value]
           ,[MimeType]
           ,[TenantId]
		   ,@StampAction
		   ,GetDate()
		   ,@StampUser
FROM TBrandAsset
WHERE BrandAssetId = @BrandAssetId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
