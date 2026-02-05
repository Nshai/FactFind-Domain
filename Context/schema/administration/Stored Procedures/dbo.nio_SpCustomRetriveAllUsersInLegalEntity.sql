SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_SpCustomRetriveAllUsersInLegalEntity]
@TenantId bigint,  
@UserId bigint
AS  
BEGIN
 
--Declarations
DECLARE @entityFlag bit
Declare @GroupId bigint

--Initialize variables .
select @GroupId = GroupId from TUser where UserId = @UserId
SET @entityFlag = 0

--Find the Legal Entity Group Id.
WHILE (@entityFlag = 0)
BEGIN
	select @entityFlag = G.LegalEntity from TGroup G where G.GroupId = @GroupId

	if (@entityFlag != 1)
	  select @GroupId = G.ParentId from TGroup G where G.GroupId = @GroupId
END

--Create a Temp Table to store the group ids.
Create Table #LegalEntityGroups
(
	GroupId bigint
)

--Next, Find all the groups in the Legal Entity
--and insert into #LegalEntityGroups
exec TraverseHierarchy @GroupId

--Select all the users in the Legal Entity.
SELECT 
	U.UserId,
	U.Identifier,
	U.Password,
	U.Email,
	U.CanLogCases,
	U.FailedAccessAttempts,
	U.PasswordHistory,
	U.Reference,
	U.SuperUser,
	U.SuperViewer,
	U.FinancialPlanningAccess,
	U.SupportUserFg,
	U.SyncPassword,
	U.Guid,
	U.Telephone,
	U.Status,
	U.ExpirePasswordOn,
	U.ConcurrencyId,
	U.GroupId,
	U.IndigoClientId,
	U.RefUserTypeId,
	U.ActiveRole,
	U.CRMContactId,
	U.IsMortgageBenchEnabled,
	U.IsMIReportDesigner,
	U.IsMIReportManager,
	U.SearchData,
	U.RecentData,
	U.RecentWork,
	U.ConcurrencyId,
	U.PasswordSalt,
	U.EmailConfirmed,
	U.LockedOutUntilDateTime,
	U.IsOutLookExtensionUser
FROM TUser U      
WHERE U.IndigoClientId = @TenantId
AND U.GroupId in (select GroupId from #LegalEntityGroups)

--Drop the Temp Table
drop table #LegalEntityGroups
	
END

GO
