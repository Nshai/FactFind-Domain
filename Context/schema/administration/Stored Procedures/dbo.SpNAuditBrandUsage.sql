SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditBrandUsage]
	@StampUser varchar (255),
	@BrandUsageId int,
	@StampAction char(1)
AS

INSERT INTO [dbo].[TBrandUsageAudit]
           ([BrandUsageId]
           ,[ScopeId]
           ,[Scope]
           ,[Application]
           ,[Tag]
           ,[BrandId]
           ,[TenantId]
           ,[Uri]
           ,[StampAction]
           ,[StampDateTime]
           ,[StampUser])
Select		[BrandUsageId]
           ,[ScopeId]
           ,[Scope]
           ,[Application]
           ,[Tag]
           ,[BrandId]
           ,[TenantId]
           ,[Uri]
		   ,@StampAction
		   ,GetDate()
		   ,@StampUser
FROM TBrandUsage
WHERE BrandUsageId = @BrandUsageId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
