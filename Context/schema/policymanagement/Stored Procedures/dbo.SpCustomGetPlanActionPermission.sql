SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpCustomGetPlanActionPermission]
@UserId bigint,
@Action varchar(50),
@PolicyBusinessId bigint

as

begin


DECLARE @CurrentStatusId bigint
DECLARE @LifeCycleId bigint
DECLARE @LifeCycleStepId bigint
DECLARE @RoleId bigint


SET @CurrentStatusId = (SELECT StatusId FROM TStatusHistory WHERE PolicyBusinessId = @PolicyBusinessId AND CurrentStatusFg = 1)
SET @LifeCycleId = (SELECT LifeCycleId FROM TPolicyBusiness WHERE PolicyBusinessId = @PolicyBusinessId)
SET @LifeCycleStepId = (SELECT LifeCycleStepId FROM TLifeCycleStep WHERE LifeCycleId = @LifeCycleId AND StatusId = @CurrentStatusId)
SET @RoleId = (SELECT ActiveRole FROM Administration..TUser WHERE UserId = @UserId)

SELECT 1 as tag,
NULL as parent,
rpa.RefPlanActionId as [RefPlanActionStatusRole!1!RefPlanActionId],
rpa.Identifier as [RefPlanActionStatusRole!1!Action],
rpasr.RefPlanActionStatusRoleId as [RefPlanActionStatusRole!1!RefPlanActionStatusRoleId]
FROM TRefPlanActionStatusRole rpasr
INNER JOIN TRefPlanAction rpa ON rpa.RefPlanActionId = rpasr.RefPlanActionId
WHERE rpasr.LifeCycleStepId = @LifeCycleStepId
AND rpasr.RoleId = @RoleId
AND (rpa.Identifier = @Action OR @Action = '')

FOR XML EXPLICIT
end
GO
