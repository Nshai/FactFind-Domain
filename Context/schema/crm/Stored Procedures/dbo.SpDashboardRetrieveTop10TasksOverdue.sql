/*
Modification History (most recent first)
Date        Author        Ref       Description
----        ---------     -------   -------------
20201030    KK			  SDA-1   Converted NH Query to SP for better performance
*/

CREATE PROCEDURE dbo.SpDashboardRetrieveTop10TasksOverdue
(
@TenantId INT,
@Userid INT,
@CurrentUserTime datetime
)
AS
BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

DECLARE @completed tinyint = 2

SELECT Top 10
 t.TaskId,
 cn.partyname clientname,
 oa.CRMContactId clientid,
 ju.partyname jointclientname,
 oa.JointCRMContactId jointclientid,
 t.duedate,
 t.Timezone,
 t.Subject,
 pr.PriorityName,
  (
    CASE WHEN priorityName = 'High' THEN 1 WHEN priorityName = 'Medium' THEN 2 WHEN priorityName = 'Low' THEN 3 ELSE 4 END
  ) AS PriorityOrder
FROM
		CRM.dbo.TTask t
		join CRM.dbo.TOrganiserActivity oa on oa.TaskId = t.TaskId
		left outer join crm.dbo.VPartyName cn on oa.CRMContactId = cn.CrmId
		left outer join CRM.dbo.TRefPriority pr on t.RefPriorityId = pr.RefPriorityId
		left outer join crm.dbo.VPartyName ju on ju.CrmId = oa.JointCRMContactId
WHERE
  t.IndigoClientId = @TenantId and
  t.AssignedToUserId = @userid and
  t.DueDate < dateadd(ms, -3, datediff(d,0,@CurrentUserTime)) and
  (t.RefTaskStatusId is null or t.RefTaskStatusId <> @completed) and
  (cn.CrmId is null or cn.IsDeleted = 0)
ORDER BY
  dateadd(
    dd,
    0,
    datediff(dd, 0, t.DueDate)
  ) asc,
  t.DueDate asc,
  PriorityOrder asc,
  t.StartDate asc

END
GO