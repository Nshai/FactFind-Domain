SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditRefLicenseType]
	@StampUser varchar (255),
	@RefLicenseTypeId bigint,
	@StampAction char(1)
AS

INSERT INTO [Administration].[dbo].[TRefLicenseTypeAudit] (
	[LicenseTypeName]
	,[RefLicenseStatusId]
	,[ConcurrencyId]		
	,[RefLicenseTypeId]
	,[StampAction]
	,[StampDateTime]
	,[StampUser]
	) 
Select 
	[LicenseTypeName]
	,[RefLicenseStatusId]
	,[ConcurrencyId]		
	,[RefLicenseTypeId]
	,@StampAction
	,GetDate()
	,@StampUser
FROM [Administration].[dbo].[TRefLicenseType]
WHERE RefLicenseTypeId = @RefLicenseTypeId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
