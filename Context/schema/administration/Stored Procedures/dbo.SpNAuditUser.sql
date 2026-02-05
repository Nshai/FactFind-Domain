SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditUser]
	@StampUser varchar (255),
	@UserId bigint,
	@StampAction char(1)
AS

INSERT INTO TUserAudit 
		( Identifier, Password, PasswordHistory, Email, 
        Telephone, Status, GroupId, SyncPassword, 
        ExpirePasswordOn, SuperUser, SuperViewer, FinancialPlanningAccess, 
        FailedAccessAttempts, WelcomePage, Reference, CRMContactId, 
        SearchData, RecentData, RecentWork, IndigoClientId, 
        SupportUserFg, ActiveRole, CanLogCases, RefUserTypeId, 
        Guid, IsMortgageBenchEnabled, IsMIReportDesigner, IsMIReportManager, 
        ConcurrencyId, LockedOutUntilDateTime, PasswordSalt, EmailConfirmed, 
		IsOutLookExtensionUser, AdvisaCentaCoreAccess, AdvisaCentaCorePlusAccess, FeAnalyticsAccess, 
		IsVoyantUser, PensionFreedomPlanner, UserId, AdvisaCentaFullAccess, AdvisaCentaFullAccessPlusLifetimePlanner,
		Timezone, Is2faEnabled, LastLoginAt, StampAction, StampDateTime, StampUser, HasGroupDataAccess, Qualification, JobTitle, Signature)
Select Identifier, Password, PasswordHistory, Email, 
        Telephone, Status, GroupId, SyncPassword, 
        ExpirePasswordOn, SuperUser, SuperViewer, FinancialPlanningAccess, 
        FailedAccessAttempts, WelcomePage, Reference, CRMContactId, 
        SearchData, RecentData, RecentWork, IndigoClientId, 
        SupportUserFg, ActiveRole, CanLogCases, RefUserTypeId, 
        Guid, IsMortgageBenchEnabled, IsMIReportDesigner, IsMIReportManager, 
        ConcurrencyId, LockedOutUntilDateTime, PasswordSalt, EmailConfirmed, 
		IsOutLookExtensionUser, AdvisaCentaCoreAccess, AdvisaCentaCorePlusAccess,FeAnalyticsAccess, 
		IsVoyantUser, PensionFreedomPlanner, UserId, AdvisaCentaFullAccess, AdvisaCentaFullAccessPlusLifetimePlanner, 
		Timezone, Is2faEnabled, LastLoginAt, @StampAction, GetDate(), @StampUser, HasGroupDataAccess, Qualification, JobTitle, Signature
FROM TUser
WHERE UserId = @UserId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
