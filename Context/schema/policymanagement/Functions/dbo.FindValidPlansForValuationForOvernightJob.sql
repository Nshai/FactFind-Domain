SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[FindValidPlansForValuationForOvernightJob]
(
@valuationProvider bigint = 0
,@IndigoClientId bigint = 0
,@AdviserCRM bigint = 0
,@RetrieveExcludedPlan bit = 0
)
returns table AS return
(

/*
09-April-2013 - KK
THIS IS AN EXACT COPY OF FindValidPlansForValuation - 
HAD TO BE INTRODUCED TO MAKE INDIGOCLIENTID REQUIRED FOR ALL OTHER CALLS, WHICH WAS TO REDUCE THE CPU SPIKES.
IN CASE OF ANY CHANGES PLEASE CHECK FindValidPlansForValuation AND VICEVERSA
HENCEFORTH THIS FUNCTION SHOULD ONLY BE CALLED FROM OVERNIGHT JOB AND NOT ANYWHERE FROM THE APPLICATION, 
FROM APPLICATION FindValidPlansForValuation SHOULD BE CALLED
*/

/*
Authored By KK On 24/09/2012
Purpose : 
                    This is to optimize and converge the plan retrieval logic for valuation in one place
                    Will return plans for any combination of provider,  client,  adviser
                                Inforce/PaidUp
                                Not Excluded
                                With Policynumber
                                Gated Plan type for the provider
                                One policy for the first owner
                                Inline - Selling Adviser as Access Granted or Servicing Adviser Access Granted Based on ExtendValuationsByServicingadviser
                                
*/
WITH SubSetOfPlan AS
(    SELECT Policydetailid, MIN(policybusinessid) TopupPolicyBusinessId  
    FROM tpolicybusiness WITH(NOLOCK)  
    where 
    ((@IndigoClientId <> 0 and IndigoClientId = @IndigoClientId) or (@IndigoClientId = 0)) 
    group by policydetailid
)	
SELECT
        T1.IndigoClientId,  T1.PolicyBusinessId, PolicyOwner.CRMContactId OwnerCRM,  
        g.ValuationProvider BaseProvider,  T4.RefProdProviderId,
        sellingAdviser.PractitionerId SellingPractitioner,  sellingUser.CRMContactId SellingCRM, 
        servicingadviser.PractitionerId ServicingPractitioner, ServicingUser.CRMContactId ServicingCRM
        ,ValueByServicingAdviser, TopupPolicyBusinessId
 From PolicyManagement..TPolicyBusiness T1 WITH(NOLOCK)                   
 Inner Join PolicyManagement..TPolicyDetail T2 WITH(NOLOCK) On T1.PolicyDetailId = T2.PolicyDetailId
 Inner Join PolicyManagement..TPolicyOwner T3 WITH(NOLOCK) On T2.PolicyDetailId = T3.PolicyDetailId AND  T3.PolicyOwnerId = (SELECT TOP 1 PolicyOwnerId FROM policymanagement..TPolicyOwner WHERE  PolicyDetailId =  T2.PolicyDetailId order by  PolicyOwnerId ASC)
 Inner Join PolicyManagement..TPlanDescription T4 WITH(NOLOCK) On T2.PlanDescriptionId = T4.PlanDescriptionId
 Inner Join TStatusHistory T8 WITH(NOLOCK) On T1.PolicyBusinessId = T8.PolicyBusinessId AND T8.CurrentStatusFG = 1
 Inner Join TStatus T9 WITH(NOLOCK) On T8.StatusId = T9.StatusId AND T9.IntelligentOfficeStatusType in ('In force', 'Paid Up')
 Inner Join PolicyManagement..TRefPlanType2ProdSubType T10 WITH(NOLOCK) On T4.RefPlanType2ProdSubTypeId = T10.RefPlanType2ProdSubTypeId
 left Join crm..TPractitioner sellingAdviser WITH (NOLOCK) On t1.PractitionerId = sellingAdviser.PractitionerId left join Administration..tuser sellingUser WITH (NOLOCK) On sellingAdviser.CRMContactId = sellingUser.CRMContactId
 left Join crm..TCRMContact PolicyOwner WITH (NOLOCK) On t3.CRMContactId = PolicyOwner.CRMContactId left join crm..TPractitioner ServicingAdviser WITH (NOLOCK) On PolicyOwner.CurrentAdviserCRMId = ServicingAdviser.CRMContactId
		        left join Administration..tuser ServicingUser WITH (NOLOCK) On ServicingAdviser.CRMContactId= ServicingUser.CRMContactId
 left join TValExcludedPlan ExcludedPlan WITH (NOLOCK) ON T1.PolicyBusinessId = Excludedplan.PolicyBusinessId
inner join 
 (select refprodproviderid as ValuationProvider, refprodproviderid PlanProvider, refplantypeid GatedPlanId, ProdSubTypeId GatedSubPlanId from TValGating WITH (NOLOCK)
UNION ALL
select  L.MappedRefProdProviderId, l.RefProdProviderId, g.RefPlanTypeId, ProdSubTypeId from TValGating G WITH (NOLOCK) 
            inner join TValLookUp L WITH (NOLOCK) on g.RefProdProviderId = L.MappedRefProdProviderId ) 
G on  t10.RefPlanTypeId = G.GatedPlanId and isnull(t10.ProdSubTypeId,0) = isnull(G.GatedSubPlanId,0) and t4.RefProdProviderId = G.PlanProvider
LEFT JOIN 
            (SELECT  Value ValueByServicingAdviser, IndigoClientId 
                                        FROM administration..TIndigoClientPreference with (nolock)  WHERE PreferenceName = 'ExtendValuationsByServicingadviser' AND Value = '1' 
             ) AdviserConfig on t1.IndigoClientId  = AdviserConfig.IndigoClientId
LEFT JOIN 
    SubSetOfPlan
					on SubSetOfPlan.TopupPolicyBusinessId = t1.PolicyBusinessId
 WHERE
 IsNull(T1.PolicyNumber,'') <> ''  and
 (
	(
		(@AdviserCRM = 0 and isnull(AdviserConfig.ValueByServicingAdviser,0) = 0 and  sellingUser.Status like 'Access Granted%')
        or
		(@AdviserCRM = 0 and isnull(AdviserConfig.ValueByServicingAdviser,0) = 1 and 
				( 
					(sellingUser.Status like 'Access Granted%') 
					or 
					(sellingUser.Status Not like 'Access Granted%' and  ServicingUser.Status like 'Access Granted%')
				)
		)
		or 
		(@AdviserCRM <> 0 and isnull(AdviserConfig.ValueByServicingAdviser,0) = 0 and sellingAdviser.CRMContactId = @AdviserCRM and sellingUser.Status like 'Access Granted%')
		or
		(@AdviserCRM <> 0 and isnull(AdviserConfig.ValueByServicingAdviser,0) = 1 and 
				( 
					(sellingAdviser.CRMContactId = @AdviserCRM and sellingUser.Status like 'Access Granted%') 
					or 
					(ServicingAdviser.CRMContactId = @AdviserCRM and sellingUser.Status Not like 'Access Granted%' and  ServicingUser.Status like 'Access Granted%')
				)
		)
	)
 )
 and 
 (
	((@IndigoClientId <> 0 and t1.IndigoClientId = @IndigoClientId) or (@IndigoClientId = 0))
 ) 
    and 
(
        ((@valuationProvider  <> 0 and G.ValuationProvider = @valuationProvider ) or (@valuationProvider  = 0))
)

   AND 
            ( (@RetrieveExcludedPlan = 1) or (@RetrieveExcludedPlan = 0 and excludedplan.PolicyBusinessId IS NULL))

	AND ( (g.ValuationProvider <> 567 and TopupPolicyBusinessId is Not null) or (g.ValuationProvider = 567 ))
)
GO
