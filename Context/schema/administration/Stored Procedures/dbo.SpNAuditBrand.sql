SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
create PROCEDURE [dbo].[SpNAuditBrand]
	@StampUser varchar (255),
	@BrandId int,
	@StampAction char(1)
AS

INSERT INTO [dbo].[TBrandAudit]
           ([BrandId]
           ,[Name]
           ,[TenantId]
           ,[StampAction]
           ,[StampDateTime]
           ,[StampUser])
Select		[BrandId]
           ,[Name]
           ,[TenantId]
		   ,@StampAction
		   ,GetDate()
		   ,@StampUser
FROM TBrand
WHERE BrandId = @BrandId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
