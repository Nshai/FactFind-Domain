SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomDashboardRetrieveGroupAdviceCases]
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

--find groups to include
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

--count service cases statuses for advisers in the selected groups
	select s.Descriptor, COUNT(*)
	from vadvicecase ac 
		INNER JOIN administration..TUser u ON u.CRMContactId = AC.AdviserCRMContactId
		INNER JOIN @Groups g ON u.GroupId = g.GroupId
		inner join TAdviceCaseStatus s with (nolock)on s.AdviceCaseStatusId =ac.StatusId
				and s.IsComplete =0
				and s.IsAutoClose=0
	GROUP BY s.Descriptor
	ORDER BY s.Descriptor

GO
