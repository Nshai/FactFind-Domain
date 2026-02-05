SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[SpCustomRetrieveObjectivesForAuthor]
@CRMContactId bigint,
@CRMContactId2 bigint = 0

AS

begin

SELECT 
1 as tag,
NULL as parent,
o.ObjectiveId as [Objective!1!ObjectiveId],
isnull(o.Objective,'') as [Objective!1!Objective],
ot.ObjectiveTypeId as [Objective!1!ObjectiveTypeId],
ot.Identifier as [Objective!1!ObjectiveType],
case 
	when o.GoalType = 2 then 'Growth With Target'
	when o.GoalType = 4 then 'Growth Without Target'
	when o.GoalType = 3 then 'Income'
end as [Objective!1!GoalType],

isnull(o.TargetAmount,'') as [Objective!1!TargetAmount],
isnull(convert(varchar(10), o.StartDate, 103),'') as [Objective!1!StartDate],
isnull(convert(varchar(10), o.TargetDate,103),'') as [Objective!1!TargetDate],
case
	when o.RiskProfileGuid is null then isnull(defaultRisk.RiskNumber,'')
	else isnull(rpc.RiskNumber,'') 
end as [Objective!1!RiskProfile],
case
	when o.RiskProfileGuid is null then isnull(defaultRisk.Descriptor,'')
	else isnull(rpc.Descriptor,'') 
end as [Objective!1!RiskDescription],
isnull(o.ReasonForChange,'') as [Objective!1!ReasonForChange],
isnull(o.RetirementAge,'') as [Objective!1!RetirementAge],
isnull(o.LumpSumAtRetirement,'') as [Objective!1!LumpSumRetirement],
c1.CRMContactId as [Objective!1!CRMContactId],
ISNULL(c1.FirstName + ' ' + c1.LastName,'') + isnull(c1.CorporateName,'') as [Objective!1!Client1Name],
isnull(c2.CRMContactId,'') as [Objective!1!CRMContactId2],
ISNULL(c2.FirstName + ' ' + c2.LastName,'') + isnull(c2.CorporateName,'') as [Objective!1!Client2Name]
FROM TObjective o
JOIN TObjectiveType ot on ot.ObjectiveTypeId = o.ObjectiveTypeId
JOIN CRM..TCRMContact c1 on c1.CRMContactId = o.CRMContactId
LEFT JOIN CRM..TCRMContact c2 on c2.CRMContactId = o.CRMContactId2
LEFT JOIN PolicyManagement..TRiskProfileCombined rpc on rpc.Guid = o.RiskProfileGuid
CROSS APPLY dbo.FnGetDefaultRiskProfileForObjective(o.ObjectiveId) defaultRisk

WHERE o.CRMContactId in (@CRMContactId, @CRMContactId2)

FOR XML EXPLICIT

END




GO
