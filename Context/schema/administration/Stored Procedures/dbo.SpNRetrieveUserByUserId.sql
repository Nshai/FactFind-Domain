SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveUserByUserId]
	@UserId bigint
AS

SELECT T1.UserId, T1.Identifier, T1.Password, T1.PasswordHistory, T1.Email, T1.Telephone, 
	T1.Status, T1.GroupId, T1.SyncPassword, T1.ExpirePasswordOn, T1.SuperUser, T1.SuperViewer, 
	T1.FinancialPlanningAccess, T1.FailedAccessAttempts, T1.WelcomePage, T1.Reference, T1.CRMContactId, T1.SearchData, 
	T1.RecentData, T1.RecentWork, T1.IndigoClientId, T1.SupportUserFg, T1.ActiveRole, T1.CanLogCases, 
	T1.RefUserTypeId, T1.Guid, T1.IsMortgageBenchEnabled, T1.ConcurrencyId
FROM TUser  T1
WHERE T1.UserId = @UserId
GO
