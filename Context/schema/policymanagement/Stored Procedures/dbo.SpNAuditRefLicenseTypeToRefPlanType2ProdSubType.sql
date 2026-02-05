SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditRefLicenseTypeToRefPlanType2ProdSubType]
	@StampUser varchar (255),
	@RefLicenseTypeToRefPlanType2ProdSubTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO [PolicyManagement].[dbo].[TRefLicenseTypeToRefPlanType2ProdSubTypeAudit] (
	[RefLicenseTypeId]
	,[RefPlanType2ProdSubTypeId]
	,[ConcurrencyId]		
	,[RefLicenseTypeToRefPlanType2ProdSubTypeId]
	,[StampAction]
	,[StampDateTime]
	,[StampUser]
	) 
Select 
	[RefLicenseTypeId]
	,[RefPlanType2ProdSubTypeId]
	,[ConcurrencyId]		
	,[RefLicenseTypeToRefPlanType2ProdSubTypeId]
	,@StampAction
	,GetDate()
	,@StampUser
FROM [PolicyManagement].[dbo].[TRefLicenseTypeToRefPlanType2ProdSubType]
WHERE RefLicenseTypeToRefPlanType2ProdSubTypeId = @RefLicenseTypeToRefPlanType2ProdSubTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
