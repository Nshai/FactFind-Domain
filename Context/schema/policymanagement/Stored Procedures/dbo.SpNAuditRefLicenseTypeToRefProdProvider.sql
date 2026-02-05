SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditRefLicenseTypeToRefProdProvider]
	@StampUser varchar (255),
	@RefLicenseTypeToRefProdProviderId bigint,
	@StampAction char(1)
AS

INSERT INTO [PolicyManagement].[dbo].[TRefLicenseTypeToRefProdProviderAudit] (
	[RefLicenseTypeId]
	,[RefProdproviderId]
	,[ConcurrencyId]		
	,[RefLicenseTypeToRefProdProviderId]
	,[StampAction]
	,[StampDateTime]
	,[StampUser]
	) 
Select 
	[RefLicenseTypeId]
	,[RefProdproviderId]
	,[ConcurrencyId]		
	,[RefLicenseTypeToRefProdProviderId]
	,@StampAction
	,GetDate()
	,@StampUser
FROM [PolicyManagement].[dbo].[TRefLicenseTypeToRefProdProvider]
WHERE RefLicenseTypeToRefProdProviderId = @RefLicenseTypeToRefProdProviderId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
