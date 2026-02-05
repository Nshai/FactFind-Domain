SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveWrapperPolicyBusinessLinkedDetails]     
 @PolicyBusinessId bigint      
AS  
    
/*  
Declare @PolicyBusinessId bigint    
Set @PolicyBusinessId = 4788828 --2555782    
*/  
    
--This Sp is used within Valuations to help create the request and also list plans that can be updated re fund information    
    
Declare @ParentPolicyBusinessId bigint, @RefProdProviderId bigint  
Declare @UseMasterPlan bit, @RefPlanType2ProdSubTypeId bigint      
  
  
--Get plan specific details        
Select @RefProdProviderId = C.RefProdProviderId, @UseMasterPlan = 0, @RefPlanType2ProdSubTypeId = c.RefPlanType2ProdSubTypeId      
From PolicyManagement..TPolicyBusiness A WITH(NOLOCK)        
Inner Join PolicyManagement..TPolicyDetail B WITH(NOLOCK) On A.PolicyDetailId = B.PolicyDetailId              
Inner Join PolicyManagement..TPlanDescription C WITH(NOLOCK) On C.PlanDescriptionId = B.PlanDescriptionId              
Where A.PolicyBusinessId = @PolicyBusinessId          
        
  
--check to see if its a Linked Provider  
If exists(select 1 from PolicyManagement..TValLookUp WITH(NOLOCK) where RefProdProviderId = @RefProdProviderId)          
begin          
 Select @RefProdProviderId = MappedRefProdProviderId           
 from PolicyManagement..TValLookUp WITH(NOLOCK)         
 where RefProdProviderId = @RefProdProviderId          
end           
  
  
-- Check if the plan type is configured as a wrapper plan type   
--i.e. its its an elevate sub plan  
--if so we need to use the master plan for CE  
--need to have the ability to configure which plan to use for CE      
if exists (select 1 from PolicyManagement..tvalgating a      
 inner join PolicyManagement..TValWrapperPlanType b on a.valgatingid = b.valgatingid      
 where a.refprodproviderid = @RefProdProviderId      
 and b.RefPlanType2ProdSubTypeId = @RefPlanType2ProdSubTypeId)       
Set @UseMasterPlan = 1     
  
  
-- Get parent PolicyBusinessId if passed in @PolicyBusinessId is a linked to wrapper        
if @UseMasterPlan = 1  
begin        
 If exists(select 1 from PolicyManagement..TWrapperPolicyBusiness  where PolicyBusinessId = @PolicyBusinessId)        
 Begin  
  Select @ParentPolicyBusinessId = IsNull(ParentPolicyBusinessId,0)  
  From PolicyManagement..TWrapperPolicyBusiness WITH(NOLOCK)         
  Where PolicyBusinessId = @PolicyBusinessId  
  
  --if we haven't found the @ParentPolicyBusinessId from the TWrapperPolicyBusiness get it the long way round    
  --because if we have just added a WRAP plan and no other sub-plans, no entries exists in TWrapperPolicyBusiness    
  if @ParentPolicyBusinessId is Null    
  begin    
   Select @ParentPolicyBusinessId = IsNull(A.PolicyBusinessId,0)    
   From PolicyManagement..TPolicyBusiness A with(nolock)    
   Inner Join PolicyManagement..TPolicyDetail B with(nolock) On B.PolicyDetailId = A.PolicyDetailId    
   Inner Join PolicyManagement..TPlanDescription C with(nolock) On C.PlanDescriptionId = B.PlanDescriptionId    
   Inner Join PolicyManagement..TRefPlanType2ProdSubType D with(nolock) On D.RefPlanType2ProdSubTypeId = C.RefPlanType2ProdSubTypeId    
   Inner Join PolicyManagement..TRefPlanType E with(nolock) On E.RefPlanTypeId = D.RefPlanTypeId    
   Where A.PolicyBusinessId = @PolicyBusinessId And E.IsWrapperFg = 1     
  End   
  
  
  --just to be safe  
  set @PolicyBusinessId = @ParentPolicyBusinessId  
 End  
end       
  
--Check that the policyBusiness passed in is valid and its the master plan id - added 05/03/2010  
if @ParentPolicyBusinessId is Null   
begin  
  
Select @ParentPolicyBusinessId = IsNull(T1.PolicyBusinessId,0)    
From PolicyManagement..TPolicyBusiness T1 WITH(NOLOCK)              
Inner Join PolicyManagement..TPolicyDetail T2 WITH(NOLOCK) On T1.PolicyDetailId = T2.PolicyDetailId --941              
Inner Join PolicyManagement..TPolicyOwner T3 WITH(NOLOCK) On T2.PolicyDetailId = T3.PolicyDetailId              
Inner Join PolicyManagement..TPlanDescription T4 WITH(NOLOCK) On T2.PlanDescriptionId = T4.PlanDescriptionId                 
--Inner Join PolicyManagement..TRefProdProvider T5 WITH(NOLOCK) On T4.RefProdProviderId = T5.RefProdProviderId              
Inner Join PolicyManagement..TValProviderConfig T7 WITH(NOLOCK) On T7.RefProdProviderId = @RefProdProviderId
    
Inner Join PolicyManagement.dbo.TValGating valgating WITH(NOLOCK)       
On valgating.RefProdProviderId = T7.RefProdProviderId        
    
--wrapper provider and plan types    
Inner Join PolicyManagement..TWrapperProvider wp WITH(NOLOCK)    
On wp.RefProdProviderId = T7.RefProdProviderId And wp.RefPlanTypeId = valgating.RefPlanTypeId   
  
Where T1.PolicyBusinessId = @PolicyBusinessId  
  
end  
  
    
--get the RefProdProviderId for @PolicyBusinessId    
Select @RefProdProviderId = C.RefProdProviderId    
From PolicyManagement..TPolicyBusiness A with(nolock)    
Inner Join PolicyManagement..TPolicyDetail B with(nolock) On B.PolicyDetailId = A.PolicyDetailId    
Inner Join PolicyManagement..TPlanDescription C with(nolock) On C.PlanDescriptionId = B.PlanDescriptionId    
Where A.PolicyBusinessId = @PolicyBusinessId    
  
  
--check to see if its a Linked Provider  
If exists(select 1 from PolicyManagement..TValLookUp WITH(NOLOCK) where RefProdProviderId = @RefProdProviderId)          
begin          
 Select @RefProdProviderId = MappedRefProdProviderId           
 from PolicyManagement..TValLookUp WITH(NOLOCK)         
 where RefProdProviderId = @RefProdProviderId          
end    
  
    
    
--list all plans for the identified @ParentPolicyBusinessId or the passed in @PolicyBusinessId (if it is a parent already!)    
Select     
 1 As Tag,    
 Null As Parent,    
 IsNull(@ParentPolicyBusinessId,0) As [WrapperPolicyBusiness!1!PolicyBusinessId],    
 IsNull(B.PolicyNumber,'') As [WrapperPolicyBusiness!1!PolicyNumber],    
 B.PractitionerId As [WrapperPolicyBusiness!1!PractitionerId],    
 IsNull(@RefProdProviderId,0) As [WrapperPolicyBusiness!1!RefProdProviderId],    
 IsNull(C.BandingTemplateId,0) As [WrapperPolicyBusiness!1!BandingTemplateId],    
 b.IndigoClientId As [WrapperPolicyBusiness!1!IndigoClientId],    
 subtype.RefPlanTypeId AS  [WrapperPolicyBusiness!1!RefPlanTypeId],    
    
 NUll As [SubPlan!2!PolicyBusinessId],    
 Null As [SubPlan!2!PolicyNumber]    
    
From PolicyManagement..TPolicyBusiness B with(nolock)     
Inner Join Commissions..TBandingTemplate C with(nolock) On B.PractitionerId = C.PractitionerId    

--RefPlanType
inner join Policymanagement..TPolicyDetail pd On pd.PolicyDetailId = b.PolicyDetailId
inner join Policymanagement..TPlanDescription pdesc on pdesc.PlanDescriptionid = pd.PlanDescriptionid 
inner join Policymanagement..TRefPlanType2ProdSubType subtype on subtype.RefPlanType2ProdSubTypeid = pdesc.RefPlanType2ProdSubTypeId

   
Where B.PolicyBusinessId = IsNull(@ParentPolicyBusinessId, @PolicyBusinessId)    
And C.DefaultFg = 1    
    
UNION    
    
Select     
 2 As Tag,    
 1 As Parent,    
 IsNull(@ParentPolicyBusinessId,0) As [WrapperPolicyBusiness!1!PolicyBusinessId],    
 IsNull(B.PolicyNumber,'') As [WrapperPolicyBusiness!1!PolicyNumber],    
 Null,    
 Null,    
 Null,    
 Null,    
 Null,
    
 A.PolicyBusinessId As [WrapperPolicyBusiness!1!PolicyBusinessId],    
 IsNull(B.PolicyNumber,'') As [WrapperPolicyBusiness!1!PolicyNumber]    
    
From PolicyManagement..TWrapperPolicyBusiness A with(nolock)    
Inner Join PolicyManagement..TPolicyBusiness B with(nolock) On A.PolicyBusinessId = B.PolicyBusinessId    
Inner Join Commissions..TBandingTemplate C with(nolock) On B.PractitionerId = C.PractitionerId    
    
Where A.ParentPolicyBusinessId = IsNull(@ParentPolicyBusinessId, @PolicyBusinessId)    
And C.DefaultFg = 1    
    
For XML EXPLICIT

GO
