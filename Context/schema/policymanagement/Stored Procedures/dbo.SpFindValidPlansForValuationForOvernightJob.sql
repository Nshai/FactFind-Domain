SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.SpFindValidPlansForValuationForOvernightJob  AS

if (select object_id('tempdb..#work0')) is not null
       drop table #work0
       
if (select object_id('tempdb..#work1')) is not null
       drop table #work1

if (select object_id('tempdb..#work2')) is not null
       drop table #work2

if (select object_id('tempdb..#work3')) is not null
       drop table #work3

if (select object_id('tempdb..#work4_ICWithSchedulesSetup')) is not null
       drop table #work4_ICWithSchedulesSetup

SELECT DISTINCT IndigoClientId INTO #work4_ICWithSchedulesSetup FROM TValSchedule

SET NOCOUNT ON

select 
T2.IndigoClientId,
T1.PolicyBusinessId,
T1.PolicyDetailId, 
T1.PractitionerId,
T2.PlandescriptionId,
T3.PolicyOwnerId,
T3.CRMContactId,
T4.RefProdProviderId,
T4.RefPlanType2ProdSubTypeId,
T8.statusid,
T1.PolicyNumber
into #work0
from TPolicyBusiness T1
join #work4_ICWithSchedulesSetup IC on IC.IndigoClientId = T1.IndigoClientId
join TPolicyDetail T2 on (T1.PolicyDetailId = T2.PolicyDetailId)
join TPolicyOwner T3 on (T1.PolicyDetailId = T3.PolicyDetailId and T3.PolicyOwnerId = (SELECT TOP 1 PolicyOwnerId FROM policymanagement..TPolicyOwner WHERE  PolicyDetailId =  T2.PolicyDetailId order by  PolicyOwnerId ASC))
join TPlanDescription T4 on (T2.PlanDescriptionId = T4.PlanDescriptionId)
join TStatusHistory T8 on (T1.PolicyBusinessId = T8.PolicyBusinessId AND T8.CurrentStatusFG = 1)
WHERE 
(T1.PolicyNumber is not null and T1.PolicyNumber != '')

select refprodproviderid as ValuationProvider, refprodproviderid PlanProvider, refplantypeid GatedPlanId, ProdSubTypeId GatedSubPlanId 
into #work1
from TValGating 
UNION ALL
select  L.MappedRefProdProviderId, l.RefProdProviderId, g.RefPlanTypeId, ProdSubTypeId 
from TValGating G  
inner join TValLookUp L  on g.RefProdProviderId = L.MappedRefProdProviderId 

SELECT  Value ValueByServicingAdviser, IndigoClientId 
into #work2
FROM administration..TIndigoClientPreference   WHERE PreferenceName = 'ExtendValuationsByServicingadviser' AND Value = '1' 

SELECT T1.Policydetailid, MIN(T1.policybusinessid) TopupPolicyBusinessId  
into #work3
FROM tpolicybusiness T1 WITH(NOLOCK)  
join #work4_ICWithSchedulesSetup IC on IC.IndigoClientId = T1.IndigoClientId
group by policydetailid

SELECT XX.IndigoClientId,  XX.PolicyBusinessId, PolicyOwner.CRMContactId OwnerCRM,g.ValuationProvider BaseProvider,  XX.RefProdProviderId, sellingAdviser.PractitionerId SellingPractitioner,  sellingUser.CRMContactId SellingCRM, servicingadviser.PractitionerId ServicingPractitioner, ServicingUser.CRMContactId ServicingCRM,ValueByServicingAdviser, TopupPolicyBusinessId
,sellingUser.Status SellingAdviserStatus, ServicingUser.Status ServicingAdviserStatus
from #work0 XX
Inner Join TStatus T9  On XX.StatusId = T9.StatusId AND T9.IntelligentOfficeStatusType in ('In force', 'Paid Up')
Inner Join PolicyManagement..TRefPlanType2ProdSubType XX0  On XX.RefPlanType2ProdSubTypeId = XX0.RefPlanType2ProdSubTypeId
left Join crm..TPractitioner sellingAdviser  On XX.PractitionerId = sellingAdviser.PractitionerId left join Administration..tuser sellingUser  On sellingAdviser.CRMContactId = sellingUser.CRMContactId
left Join crm..TCRMContact PolicyOwner  On XX.CRMContactId = PolicyOwner.CRMContactId left join crm..TPractitioner ServicingAdviser  On PolicyOwner.CurrentAdviserCRMId = ServicingAdviser.CRMContactId
left join Administration..tuser ServicingUser  On ServicingAdviser.CRMContactId= ServicingUser.CRMContactId
left join TValExcludedPlan ExcludedPlan  ON XX.PolicyBusinessId = Excludedplan.PolicyBusinessId
inner join #work1 G on  XX0.RefPlanTypeId = G.GatedPlanId and isnull(XX0.ProdSubTypeId,0) = isnull(G.GatedSubPlanId,0) and XX.RefProdProviderId = G.PlanProvider
LEFT JOIN #work2 AdviserConfig on XX.IndigoClientId  = AdviserConfig.IndigoClientId
LEFT JOIN #work3 on TopupPolicyBusinessId = XX.PolicyBusinessId
WHERE 
	((isnull(AdviserConfig.ValueByServicingAdviser,0) = 0 and  sellingUser.Status like 'Access Granted%')
	or 
	(isnull(AdviserConfig.ValueByServicingAdviser,0) = 1 
					and((sellingUser.Status like 'Access Granted%') 
					or 
					(sellingUser.Status Not like 'Access Granted%' and  ServicingUser.Status like 'Access Granted%'))))
and excludedplan.PolicyBusinessId IS NULL
and ( (g.ValuationProvider <> 567 and TopupPolicyBusinessId is Not null) or (g.ValuationProvider = 567 ))
GO