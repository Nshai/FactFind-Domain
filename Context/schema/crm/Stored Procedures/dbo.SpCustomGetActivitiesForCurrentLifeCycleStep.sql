SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[SpCustomGetActivitiesForCurrentLifeCycleStep]
@PolicyBusinessId bigint

as

DECLARE @CurrentStatusId bigint
DECLARE @LifeCycleId bigint
DECLARE @LifeCycleStepId bigint

SELECT 
1 as tag,
NULL as parent,
pb.PolicyBusinessId as [PolicyBusiness!1!PolicyBusinessId],
u.UserId as [PolicyBusiness!1!PractitionerUserId],
po.CRMContactId as [PolicyBusiness!1!Owner1CRMContactId],
null  as [ActivityCategory!2!ActivityCategoryId],
null as [ActivityCategory!2!Name],
null as [ActivityCategory!2!ClientRelatedFg],
null as [ActivityCategory!2!PlanRelatedFg]
FROM PolicyManagement..TPolicyBusiness pb 
JOIN TPractitioner p ON p.PractitionerId = pb.PractitionerId
JOIN Administration..TUser u ON u.CRMContactId = p.CRMContactId
JOIN PolicyManagement..TPolicyOwner po ON po.PolicyDetailId = pb.PolicyDetailId
JOIN 
	(SELECT MIN(PolicyOwnerId) as PolicyOwnerId
		FROM PolicyManagement..TPolicyOwner po
		JOIN PolicyManagement..TPolicyBusiness pb ON pb.PolicyDetailId = po.PolicyDetailId
		WHERE pb.PolicyBusinessId = @PolicyBusinessId
		GROUP BY po.PolicyDetailId
	) minpo ON minpo.PolicyOwnerId = po.PolicyOwnerId

WHERE pb.PolicyBusinessId = @PolicyBusinessId

UNION

SELECT 
2 as tag,
1 as parent,
pb.PolicyBusinessId,
null,
null,
ac.ActivityCategoryId,
ac.Name,
ac.ClientRelatedFg,
ac.PlanRelatedFg

FROM PolicyManagement..TPolicyBusiness pb 
JOIN PolicyManagement..TStatusHistory sh ON sh.PolicyBusinessId = pb.PolicyBusinessId
JOIN PolicyManagement..TLifeCycleStep lcs ON lcs.LifeCycleId = pb.LifeCycleId AND lcs.StatusId = sh.StatusId
JOIN TActivityCategory2LifeCycleStep ac2lcs ON ac2lcs.LifeCycleStepId = lcs.LifeCycleStepId
JOIN TActivityCategory ac ON ac.ActivityCategoryId = ac2lcs.ActivityCategoryId
WHERE pb.PolicyBusinessId = @PolicyBusinessId
AND sh.CurrentStatusFg = 1

ORDER BY [PolicyBusiness!1!PolicyBusinessId],[ActivityCategory!2!ActivityCategoryId]
FOR XML EXPLICIT
GO
