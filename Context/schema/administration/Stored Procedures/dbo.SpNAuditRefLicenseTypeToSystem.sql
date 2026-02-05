SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditRefLicenseTypeToSystem]
	@StampUser varchar (255),
	@RefLicenseTypeToSystemId bigint,
	@StampAction char(1)
AS

INSERT INTO [dbo].[TRefLicenseTypeToSystemAudit] (
	[RefLicenseTypeId]
	,[SystemId]
	,[ConcurrencyId]		
	,[RefLicenseTypeToSystemId]
	,[StampAction]
	,[StampDateTime]
	,[StampUser]
	) 
Select 
	[RefLicenseTypeId]
	,[SystemId]
	,[ConcurrencyId]		
	,[RefLicenseTypeToSystemId]
	,@StampAction
	,GetDate()
	,@StampUser
FROM [dbo].[TRefLicenseTypeToSystem]
WHERE RefLicenseTypeToSystemId = @RefLicenseTypeToSystemId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
