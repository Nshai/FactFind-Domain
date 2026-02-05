SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCollideUserByIdAndConcurrencyId]
	@UserId bigint,
	@ConcurrencyId int

AS

BEGIN
	SELECT
		T1.UserId AS OriginalUserId, 
		T1.Identifier AS OriginalIdentifier, 
		T2.Identifier AS CurrentIdentifier, 
		T1.Password AS OriginalPassword, 
		T2.Password AS CurrentPassword, 
		T1.PasswordHistory AS OriginalPasswordHistory, 
		T2.PasswordHistory AS CurrentPasswordHistory, 
		T1.Email AS OriginalEmail, 
		T2.Email AS CurrentEmail, 
		T1.Telephone AS OriginalTelephone, 
		T2.Telephone AS CurrentTelephone, 
		T1.Status AS OriginalStatus, 
		T2.Status AS CurrentStatus, 
		T1.GroupId AS OriginalGroupId, 
		T2.GroupId AS CurrentGroupId, 
		T1.SyncPassword AS OriginalSyncPassword, 
		T2.SyncPassword AS CurrentSyncPassword, 
		T1.ExpirePasswordOn AS OriginalExpirePasswordOn, 
		T2.ExpirePasswordOn AS CurrentExpirePasswordOn, 
		T1.SuperUser AS OriginalSuperUser, 
		T2.SuperUser AS CurrentSuperUser, 
		T1.SuperViewer AS OriginalSuperViewer, 
		T2.SuperViewer AS CurrentSuperViewer, 
		T1.FinancialPlanningAccess AS OriginalFinancialPlanningAccess, 
		T2.FinancialPlanningAccess AS CurrentFinancialPlanningAccess, 
		T1.FailedAccessAttempts AS OriginalFailedAccessAttempts, 
		T2.FailedAccessAttempts AS CurrentFailedAccessAttempts, 
		T1.WelcomePage AS OriginalWelcomePage, 
		T2.WelcomePage AS CurrentWelcomePage, 
		T1.Reference AS OriginalReference, 
		T2.Reference AS CurrentReference, 
		T1.CRMContactId AS OriginalCRMContactId, 
		T2.CRMContactId AS CurrentCRMContactId, 
		T1.SearchData AS OriginalSearchData, 
		T2.SearchData AS CurrentSearchData, 
		T1.RecentData AS OriginalRecentData, 
		T2.RecentData AS CurrentRecentData, 
		T1.RecentWork AS OriginalRecentWork, 
		T2.RecentWork AS CurrentRecentWork, 
		T1.IndigoClientId AS OriginalIndigoClientId, 
		T2.IndigoClientId AS CurrentIndigoClientId, 
		T1.SupportUserFg AS OriginalSupportUserFg, 
		T2.SupportUserFg AS CurrentSupportUserFg, 
		T1.ActiveRole AS OriginalActiveRole, 
		T2.ActiveRole AS CurrentActiveRole, 
		T1.CanLogCases AS OriginalCanLogCases, 
		T2.CanLogCases AS CurrentCanLogCases, 
		T1.RefUserTypeId AS OriginalRefUserTypeId, 
		T2.RefUserTypeId AS CurrentRefUserTypeId, 
		T1.Guid AS OriginalGuid, 
		T2.Guid AS CurrentGuid, 
		T1.IsMortgageBenchEnabled AS OriginalIsMortgageBenchEnabled, 
		T2.IsMortgageBenchEnabled AS CurrentIsMortgageBenchEnabled, 
		T2.ConcurrencyId AS CurrentConcurrencyId
	FROM TUser T2
	LEFT OUTER JOIN TUserAudit T1
	ON T1.UserId = T2.UserId
	WHERE T1.UserId = @UserId AND T1.ConcurrencyId = @ConcurrencyId

END
RETURN (0)
GO
