SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_SpCustomLogoutAllUsers]
	@TenantId bigint,
	@KeyUserId bigint,
	@StampUser varchar (255)
AS
INSERT INTO TUserAudit (
	Identifier, [Password], PasswordHistory, Email, Telephone, [Status], GroupId, SyncPassword, ExpirePasswordOn, SuperUser, SuperViewer, 
	FinancialPlanningAccess, FailedAccessAttempts, WelcomePage, Reference, CRMContactId, SearchData, RecentData, RecentWork, IndigoClientId, 
	SupportUserFg, ActiveRole, CanLogCases, RefUserTypeId, [Guid], ConcurrencyId, IsMortgageBenchEnabled, IsMIReportDesigner, IsMIReportManager, 
	UserId, Timezone, StampAction, StampDateTime, StampUser)
SELECT
	Identifier, [Password], PasswordHistory, Email, Telephone, [Status], GroupId, SyncPassword, ExpirePasswordOn, SuperUser, SuperViewer, 
	FinancialPlanningAccess, FailedAccessAttempts, WelcomePage, Reference, CRMContactId, SearchData, RecentData, RecentWork, IndigoClientId, 
	SupportUserFg, ActiveRole, CanLogCases, RefUserTypeId, [Guid], ConcurrencyId, IsMortgageBenchEnabled, IsMIReportDesigner, IsMIReportManager, 
	UserId, Timezone, 'U', GETDATE(), @StampUser
FROM 
	TUser T1
WHERE 
	T1.IndigoClientId = @TenantId
	AND T1.[Status] = 'Access Granted - Logged In'
	AND T1.UserId != @KeyUserId

UPDATE T1
SET 
	T1.[Status] = 'Access Granted - Not Logged In',
    T1.ConcurrencyId = T1.ConcurrencyId + 1
FROM 
	TUser T1
WHERE 
	T1.IndigoClientId = @TenantId
	AND T1.[Status] = 'Access Granted - Logged In'
	AND T1.UserId != @KeyUserId

SELECT [rowcount] = @@ROWCOUNT
GO