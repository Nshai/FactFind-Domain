
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomDashboardRetrieveGroupClients]
	@Userid bigint,
	@GroupId bigint = 0
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

-- basic security check
IF NOT EXISTS(
	select 1
	FROM administration..TUser u
	JOIN administration..TGroup g on g.IndigoClientId = u.IndigoClientId
	WHERE u.UserId = @UserId AND g.GroupId = @GroupId
) 
RETURN

declare @TotalPersonClients bigint
declare @TotalCorporateClients bigint
declare @TotalTrustClients bigint
declare @Groups TABLE (GroupId bigint)

if @GroupId > 0
	begin
		INSERT INTO @Groups 
		SELECT GroupId FROM administration..fnGetChildGroupsForGroup(@GroupId,0)
	end
else
	begin
		INSERT INTO @Groups 
		SELECT GroupId FROM administration..fnGetChildGroupsForGroup(0,@UserId)	
	end


SET @TotalPersonClients = (
	SELECT COUNT(c.CRMContactId) 
	FROM crm..TCRMContact c WITH (NOLOCK)
	INNER JOIN administration..TUser u ON u.CRMContactId = c.CurrentAdviserCrmId
	INNER JOIN @Groups g ON u.GroupId = g.GroupId
	WHERE c.RefCRMContactStatusId = 1
	AND c.CRMContactType = 1
	AND ISNULL(c.ArchiveFg,0) = 0
		)

SET @TotalCorporateClients = (
	SELECT COUNT(c.CRMContactId) 
	FROM crm..TCRMContact c WITH (NOLOCK)
	INNER JOIN administration..TUser u ON u.CRMContactId = c.CurrentAdviserCrmId
	INNER JOIN @Groups g ON u.GroupId = g.GroupId
	WHERE c.RefCRMContactStatusId = 1
	AND c.CRMContactType = 3
	AND ISNULL(c.ArchiveFg,0) = 0
		)

SET @TotalTrustClients = (
	SELECT COUNT(c.CRMContactId) 
	FROM crm..TCRMContact c WITH (NOLOCK)
	INNER JOIN administration..TUser u ON u.CRMContactId = c.CurrentAdviserCrmId
	INNER JOIN @Groups g ON u.GroupId = g.GroupId
	WHERE c.RefCRMContactStatusId = 1
	AND c.CRMContactType = 2
	AND ISNULL(c.ArchiveFg,0) = 0
		)
		
SELECT 
@TotalPersonClients as TotalPersonClients, 
@TotalCorporateClients as TotalCorporateClients, 
@TotalTrustClients as TotalTrustClients, 
@TotalPersonClients + @TotalCorporateClients + @TotalTrustClients as TotalClients


GO
