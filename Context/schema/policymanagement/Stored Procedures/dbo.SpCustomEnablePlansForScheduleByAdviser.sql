SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpCustomEnablePlansForScheduleByAdviser] @StampUser bigint, @UserCRMContactId bigint, @RefProdProviderId bigint

as


declare @IndigoClientId bigint
            
--Need to identify which indigoclient this user maps to for IsLocked       
Select @IndigoClientId = IndClientId      
From CRM..TCRMContact       
Where CRMContactId = @UserCRMContactId      
            
            
--need to find all plans where the Selling Adviser = @PractitionerId            
-- then link them under/with the portal details            
declare @PractitionerId bigint            
            
If Exists(Select 1 From CRM..TPractitioner WITH(NOLOCK) Where CRMContactId = @UserCRMContactId)            
 Select @PractitionerId = PractitionerId From CRM..TPractitioner Where CRMContactId = @UserCRMContactId            
else            
 Set @PractitionerId = 0            
  
create table #PlansTable (  
 Id bigint IDENTITY (1, 1),            
 PolicyBusinessId bigint,            
 RefProdProviderId bigint,            
 ClientCRMContactId bigint ,
 PractitionerId bigint             
)            
            
            
--Find All inforce plans with PolicyNumbers (filtered by RefProdProviderIs from TValProviderConfig) where the Selling Adviser = @PractitionerId            
Insert Into #PlansTable (PolicyBusinessId, RefProdProviderId, ClientCRMContactId,PractitionerId)            
Select T1.PolicyBusinessId, T5.RefProdProviderId, ClientCRMContactId = T3.CRMContactId,T1.PractitionerId  --  , *             
From PolicyManagement..TPolicyBusiness T1 WITH(NOLOCK)            
Inner Join PolicyManagement..TPolicyDetail T2 WITH(NOLOCK) On T1.PolicyDetailId = T2.PolicyDetailId --941            
Inner Join PolicyManagement..TPolicyOwner T3 WITH(NOLOCK) On T2.PolicyDetailId = T3.PolicyDetailId            
Inner Join PolicyManagement..TPlanDescription T4 WITH(NOLOCK) On T2.PlanDescriptionId = T4.PlanDescriptionId               
Inner Join PolicyManagement..TRefProdProvider T5 WITH(NOLOCK) On T4.RefProdProviderId = T5.RefProdProviderId            
--Left Join PolicyManagement..TValPortalSetup T6 On T5.RefProdProviderId = T6.RefProdProviderId And T6.CRMContactId = @UserCRMContactId          
Inner Join PolicyManagement..TValProviderConfig T7 WITH(NOLOCK) On T5.RefProdProviderId = T7.RefProdProviderId            
            
Inner Join TStatusHistory T8 WITH(NOLOCK) ON T1.PolicyBusinessId = T8.PolicyBusinessId AND T8.CurrentStatusFG = 1          
Inner Join TStatus T9 WITH(NOLOCK) ON T8.StatusId = T9.StatusId          
 AND T9.IntelligentOfficeStatusType = 'In force'  
  
          
--new mapping on gated products - 12/12/2006          
Inner Join PolicyManagement..TRefPlanType2ProdSubType T10 WITH(NOLOCK) On T4.RefPlanType2ProdSubTypeId = T10.RefPlanType2ProdSubTypeId          
Inner Join PolicyManagement..TValGating valgating WITH(NOLOCK)   
 On valgating.RefPlanTypeId = T10.RefPlanTypeId           
 And IsNull(valgating.ProdSubTypeId,0) = IsNull(T10.ProdSubTypeId,0)          
 And valgating.RefProdProviderId = T5.RefProdProviderId          
          
Where T1.PractitionerId = @PractitionerId And IsNull(T1.PolicyNumber,'') <> ''          
  
          
--start new code - insert lookup clients          
Insert Into #PlansTable (PolicyBusinessId, RefProdProviderId, ClientCRMContactId,PractitionerId)            
Select T1.PolicyBusinessId, T5.RefProdProviderId, ClientCRMContactId = T3.CRMContactId,T1.PractitionerId --  , *             
From PolicyManagement..TPolicyBusiness T1 WITH(NOLOCK)   
Inner Join PolicyManagement..TPolicyDetail T2 WITH(NOLOCK) On T1.PolicyDetailId = T2.PolicyDetailId --941            
Inner Join PolicyManagement..TPolicyOwner T3 WITH(NOLOCK) On T2.PolicyDetailId = T3.PolicyDetailId            
Inner Join PolicyManagement..TPlanDescription T4 WITH(NOLOCK) On T2.PlanDescriptionId = T4.PlanDescriptionId               
Inner Join PolicyManagement..TRefProdProvider T5 WITH(NOLOCK) On T4.RefProdProviderId = T5.RefProdProviderId            
          
Inner Join PolicyManagement..TValLookup T7 WITH(NOLOCK) On T5.RefProdProviderId = T7.RefProdProviderId            
          
Inner Join TStatusHistory T8 WITH(NOLOCK) ON T1.PolicyBusinessId = T8.PolicyBusinessId AND T8.CurrentStatusFG = 1          
Inner Join TStatus T9 WITH(NOLOCK) ON T8.StatusId = T9.StatusId          
 AND T9.IntelligentOfficeStatusType = 'In force'          
  
          
--new mapping on gated products - 12/12/2006          
Inner Join PolicyManagement..TRefPlanType2ProdSubType T10 WITH(NOLOCK) On T4.RefPlanType2ProdSubTypeId = T10.RefPlanType2ProdSubTypeId          
Inner Join PolicyManagement..TValGating valgating WITH(NOLOCK)   
 On valgating.RefPlanTypeId = T10.RefPlanTypeId   
 And IsNull(valgating.ProdSubTypeId,0) = IsNull(T10.ProdSubTypeId,0)          
  And valgating.RefProdProviderId = T7.MappedRefProdProviderId          
  
Where T1.PractitionerId = @PractitionerId And IsNull(T1.PolicyNumber,'') <> ''          
--end new code          
         
          
--start new code - update lookup.refproviderid to TValProviderConfig.refproviderid          
update #PlansTable          
set RefProdProviderId = OriginalId          
from           
(          
Select OriginalId = a.RefProdProviderId, lookupId = b.RefProdProviderId           
From PolicyManagement..TValProviderConfig A WITH(NOLOCK)   
Inner Join PolicyManagement..TValLookup b on b.MappedRefProdProviderId = A.RefProdProviderId          
) b          
where RefProdProviderId = lookupId          
--end new code  
  

--delete here
insert into policymanagement..TValExcludedPlanAudit (PolicyBusinessId,
RefProdProviderId,
ExcludedByUserId,
ExcludedDate,
EmailAlertSent,
ConcurrencyId,
ValExcludedPlanId,
StampAction,
StampDateTime,
StampUser)
select distinct 
b.PolicyBusinessId,
b.RefProdProviderId,
b.ExcludedByUserId,
b.ExcludedDate,
b.EmailAlertSent,
b.ConcurrencyId,
b.ValExcludedPlanId,
'D',
getdate(),
@StampUser
from #plansTable a
inner join TValExcludedPlan b on a.policybusinessid = b.policybusinessid

delete b
from #plansTable a
inner join TValExcludedPlan b on a.policybusinessid = b.policybusinessid


GO
