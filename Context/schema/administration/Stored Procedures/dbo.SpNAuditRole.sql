SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditRole]
	@StampUser varchar (255),
	@RoleId bigint,
	@StampAction char(1)
AS

INSERT INTO TRoleAudit 
( Identifier, GroupingId, SuperUser, IndigoClientId, RefLicenseTypeId,
		LicensedUserCount, Dashboard, ShowGroupDashboard, ConcurrencyId, HourlyBillingRate,		
	RoleId, StampAction, StampDateTime, StampUser) 
Select Identifier, GroupingId, SuperUser, IndigoClientId, RefLicenseTypeId,
		LicensedUserCount, Dashboard, ShowGroupDashboard, ConcurrencyId, HourlyBillingRate, 
		
	RoleId, @StampAction, GetDate(), @StampUser
FROM TRole
WHERE RoleId = @RoleId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
