create procedure SpCustomDashboardRetrievegroupTop10ProductsByCommission
@UserId bigint,	@GroupId bigint
as
begin

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	if (select objecT_id('tempdb..#work0')) is not null drop table #work0

	declare @Groups TABLE (GroupId bigint)

	-- basic security check
	IF NOT EXISTS(
		select 1
		FROM administration..TUser u
		JOIN administration..TGroup g on g.IndigoClientId = u.IndigoClientId
		WHERE u.UserId = @UserId AND g.GroupId = @GroupId
	) 
	RETURN

	DECLARE @IndigoClientId bigint
	select @IndigoClientId =u.IndigoClientId
	FROM administration..TUser u
	WHERE u.UserId = @UserId

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

	select U.CRMContactId,u.GroupId,@IndigoClientId as IndClientId
	into #work0
	from administration..TUser u 
	JOIN @Groups g ON g.GroupId = u.GroupId  
	WHERE u.IndigoClientId=@IndigoClientId

	select top 10 rpt.PlanTypeName, sum(a.Amount) as Amount
	from dbo.TDashBoardPlanTypeCommissionDN A
	JOIN #work0 B on A.CRMContactID = B.CRMContactId and A.IndigoClientId = b.IndClientId
	JOIN TRefPlanType rpt ON rpt.RefPlanTypeId = A.RefPLanTypeId  
	GROUP BY rpt.PlanTypeName
	order by 2 desc
end