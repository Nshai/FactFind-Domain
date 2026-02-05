SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditRefLicenseStatus]
	@StampUser varchar (255),
	@RefLicenseStatusId bigint,
	@StampAction char(1)
AS

INSERT INTO [Administration].[dbo].[TRefLicenseStatusAudit] (
	[StatusName]           
    ,[ConcurrencyId]	
	,[RefLicenseStatusId]
	,[StampAction]
	,[StampDateTime]
	,[StampUser]
	) 
Select 
	[StatusName]			
	,[ConcurrencyId]
	,[RefLicenseStatusId]
	,@StampAction
	,GetDate()
	,@StampUser
FROM [Administration].[dbo].[TRefLicenseStatus]
WHERE RefLicenseStatusId = @RefLicenseStatusId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
