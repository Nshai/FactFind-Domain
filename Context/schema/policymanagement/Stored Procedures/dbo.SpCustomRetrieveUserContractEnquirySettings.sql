SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--SpCustomRetrieveUserContractEnquirySettings 17775

CREATE PROCEDURE [dbo].[SpCustomRetrieveUserContractEnquirySettings] @UserCRMContactId bigint  
AS            

--SpCustomRetrieveUserContractEnquirySettings 17770
        
--NB: CRMContactId = UserCRMContactId            
         
--declare @UserCRMContactId bigint              
--set @UserCRMContactId = 1035819--392129        
        
--select *from administration..tuser where userid = 8928        
          
Declare @CertificateId bigint, @LastCheckedOn datetime, @IsRevoked bit, @HasExpired bit, @IndigoClientId bigint         
            
Select @CertificateId = 0, @LastCheckedOn = '', @IsRevoked = 0, @HasExpired = 0            
            
Select             
 @CertificateId = IsNull(CertificateId,0),            
 @LastCheckedOn = IsNull(LastCheckedOn,''),          
 @IsRevoked = IsNull(IsRevoked,''),            
 @HasExpired = IsNull(HasExpired,'')            
From Administration..TCertificate             
Where CRMContactId = @UserCRMContactId          
      
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
  
--test  
--drop table #PlansTable  
  
create table #PlansTable (  
 Id bigint IDENTITY (1, 1),            
 PolicyBusinessId bigint,            
 RefProdProviderId bigint,            
 ClientCRMContactId bigint            
)            
            
            
--Find All inforce plans with PolicyNumbers (filtered by RefProdProviderIs from TValProviderConfig) where the Selling Adviser = @PractitionerId            
Insert Into #PlansTable (PolicyBusinessId, RefProdProviderId, ClientCRMContactId)            
Select T1.PolicyBusinessId, T5.RefProdProviderId, ClientCRMContactId = T3.CRMContactId --  , *             
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
Insert Into #PlansTable (PolicyBusinessId, RefProdProviderId, ClientCRMContactId)            
Select T1.PolicyBusinessId, T5.RefProdProviderId, ClientCRMContactId = T3.CRMContactId --  , *             
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
  
  
/*          
--start test          
Select A.* , C.CorporateName          
From #PlansTable a          
Inner Join PolicyManagement..TRefProdProvider b on a.RefProdProviderId = b.RefProdProviderId          
Inner Join CRM..TCRMContact c on b.CRMContactId = c.CRMContactId          
where C.CorporateName like 'Clerical m%'          
  
Select A.policybusinessid, count(*)  
From #PlansTable a          
Inner Join PolicyManagement..TRefProdProvider b on a.RefProdProviderId = b.RefProdProviderId          
Inner Join CRM..TCRMContact c on b.CRMContactId = c.CRMContactId          
where C.CorporateName like 'Clerical m%'          
group by policybusinessid  
  
--end test          
*/         

declare @PlanCountTable table (            
 Id bigint IDENTITY (1, 1),            
 RefProdProviderId bigint,             
 PlanCount bigint            
 )            
  
  
Insert Into @PlanCountTable (RefProdProviderId, PlanCount)            
Select A.RefProdProviderId, Count(policybusinessid)            
From             
(Select RefProdProviderId, policybusinessid = isnull(policybusinessid,0) 
	From #PlansTable b
	where not exists (select 1 from PolicyManagement..TValExcludedPlan a where a.policybusinessid = b.policybusinessid)
Group By RefProdProviderId, isnull(policybusinessid,0)
) A Group By A.RefProdProviderId


declare @ExcludedPlanCountTable table (            
 Id bigint IDENTITY (1, 1),            
 RefProdProviderId bigint,             
 PlanCount bigint            
 )            
  
  
Insert Into @ExcludedPlanCountTable (RefProdProviderId, PlanCount)            
Select A.RefProdProviderId, Count(policybusinessid)            
From             
(Select RefProdProviderId, policybusinessid = isnull(policybusinessid,0) 
	From #PlansTable b
	where exists (select 1 from PolicyManagement..TValExcludedPlan a where a.policybusinessid = b.policybusinessid)
Group By RefProdProviderId, isnull(policybusinessid,0)
) A Group By A.RefProdProviderId 

            
declare @ClientCountTable table (            
 Id bigint IDENTITY (1, 1),            
 RefProdProviderId bigint,             
 ClientCount bigint            
 )            
            
Insert Into @ClientCountTable (RefProdProviderId, ClientCount)            
Select A.RefProdProviderId, Count(ClientCRMContactId)            
From             
(Select RefProdProviderId, ClientCRMContactId From #PlansTable Group By RefProdProviderId, ClientCRMContactId            
) A Group By A.RefProdProviderId            
          
          
/*          
--start test             
Select A.* , C.CorporateName          
from @ClientCountTable  a          
Inner Join PolicyManagement..TRefProdProvider b on a.RefProdProviderId = b.RefProdProviderId          
Inner Join CRM..TCRMContact c on b.CRMContactId = c.CRMContactId          
--where C.CorporateName like 'fid%'          
--end test           
*/          
  
  
----Main Select  
  
          
Select Distinct            
 1 AS Tag,              
 NULL AS Parent,          
 ISNull(T1.ValProviderConfigId,'') AS [ValProviderConfig!1!ValProviderConfigId],          
 IsNull(T1.RefProdProviderId,'') AS [ValProviderConfig!1!RefProdProviderId],              
        
 Case         
 When IsNull(T3.CorporateName,'') = 'Seven Investment Management' Then '7IM'        
 Else IsNull(T3.CorporateName,'')         
 End AS [ValProviderConfig!1!ProviderName],        
        
 Case When IsNull(T1.AuthenticationType,'') = '1' Then 'UniPass' Else 'Non-Unipass' End AS [ValProviderConfig!1!Type],          
 IsNull(T1.HowToXML,'') AS [ValProviderConfig!1!HowToXML],         
          
 IsNull(T4.ValPortalSetupId,'') AS [ValProviderConfig!1!ValPortalSetupId],          
 IsNull(T4.ConcurrencyId,'') AS [ValProviderConfig!1!ConcurrencyId],          
 IsNull(T4.CRMContactId,'') AS [ValProviderConfig!1!CRMContactId],          
 IsNull(T4.UserName,'') AS [ValProviderConfig!1!UserName],          
 IsNull(T4.Password,'') AS [ValProviderConfig!1!Password],          
 IsNull(T4.ShowHowToScreen,'1') AS [ValProviderConfig!1!ShowHowToScreen],          
 IsNull(A.ClientCount,0) AS [ValProviderConfig!1!ClientCount],            
 IsNull(B.PlanCount,0) AS [ValProviderConfig!1!PlanCount],  
 IsNull(C.PlanCount,0) AS [ValProviderConfig!1!ExcludedPlanCount],  
 ISNULL(T1.PasswordEncryption, '') AS [ValProviderConfig!1!PasswordEncryption],    
      
 Case       
 When IsNull(TFirmSch.ValScheduleId, 0) = 0 Then 0      
 When IsNull(TFirmSch.ValScheduleId, 0) <> 0 Then 1      
 End AS [ValProviderConfig!1!IsLocked],      
          
 IsNuLL(CONVERT(varchar(24), TSch.StartDate, 120),'') AS [ValProviderConfig!1!ScheduleValuationStartDate],            
 IsNull(TSch.Frequency,'') AS [ValProviderConfig!1!ScheduleValuationFrequency],      
 IsNull(TSchItemOUT.HasScheduledItems,0) AS [ValProviderConfig!1!HasScheduledItems],      
          
 IsNull(@CertificateId,'') AS [ValProviderConfig!1!CertificateId],          
 IsNull(Convert(varchar(24), @LastCheckedOn, 113),'') AS [ValProviderConfig!1!LastCheckedOn],          
 IsNull(@IsRevoked,'') AS [ValProviderConfig!1!IsRevoked],          
 IsNull(@HasExpired,'') AS [ValProviderConfig!1!HasExpired]          
          
From PolicyManagement.dbo.TValProviderConfig T1 WITH(NOLOCK)   
          
Inner Join PolicyManagement.dbo.TRefProdProvider T2 WITH(NOLOCK)     
On T1.RefProdProviderId = T2.RefProdProviderId              
          
Inner Join CRM.dbo.TCRMContact T3 WITH(NOLOCK)   
On T2.CRMContactId = T3.CRMContactId          
          
Inner Join PolicyManagement.dbo.TValPortalSetup T4 WITH(NOLOCK)   
On T1.RefProdProviderId = T4.RefProdProviderId And T4.CRMContactId = @UserCRMContactId          
          
Left Join @ClientCountTable A On A.RefProdProviderId = T1.RefProdProviderId              
Left Join @PlanCountTable B On B.RefProdProviderId = T1.RefProdProviderId             
Left Join @ExcludedPlanCountTable C On C.RefProdProviderId = T1.RefProdProviderId
/*  
Left Join (Select RefProdProviderId, PlanCount = Count(IsNull(PolicyBusinessId,0))            
 From #PlansTable Group By RefProdProviderId ) B On B.RefProdProviderId = T1.RefProdProviderId          
*/  
          
Left Join PolicyManagement.dbo.TValSchedule TSch WITH(NOLOCK)   
 On TSch.RefProdProviderId = T1.RefProdProviderId             
 And TSch.ScheduledLevel = 'adviser'            
 And TSch.PortalCRMContactId = T4.CRMContactId -- Added this on 31/08/2006            
            
Left Join             
(Select TSchIN.RefProdProviderId, HasScheduledItems = Count(TSchItemIN.ValScheduleId)            
 From PolicyManagement.dbo.TValSchedule TSchIN WITH(NOLOCK)   
 Left Join PolicyManagement.dbo.TValScheduleItem TSchItemIN WITH(NOLOCK) On TSchIN.ValScheduleId = IsNull(TSchitemIN.ValScheduleId,0)            
 Where IsNull(TSchItemIN.ValScheduleId,0) is Not Null And TSchIN.ScheduledLevel = 'adviser'            
 Group By TSchIN.RefProdProviderId            
) TSchItemOUT On TSchItemOUT.RefProdProviderId = T1.RefProdProviderId           
      
--Firm Schedule - to see is firm schedule is on      
Left Join PolicyManagement.dbo.TValSchedule TFirmSch WITH(NOLOCK)     
 On TFirmSch.RefProdProviderId = T4.RefProdProviderId      
 And TFirmSch.IndigoClientId = @IndigoClientId      
 And TFirmSch.ScheduledLevel = 'firm'          
  
Where IsNull(T1.AuthenticationType,0) = 0          
          
union           
          
Select Distinct            
 1 AS Tag,              
 NULL AS Parent,          
 ISNull(T1.ValProviderConfigId,'') AS [ValProviderConfig!1!ValProviderConfigId],          
 IsNull(T1.RefProdProviderId,'') AS [ValProviderConfig!1!RefProdProviderId],              
 IsNull(T3.CorporateName,'') AS [ValProviderConfig!1!ProviderName],          
 Case When IsNull(T1.AuthenticationType,'') = '1' Then 'UniPass' Else 'Non-Unipass' End AS [ValProviderConfig!1!Type],          
 IsNull(T1.HowToXML,'') AS [ValProviderConfig!1!HowToXML],          
          
 '0' AS [ValProviderConfig!1!ValPortalSetupId],          
 Null AS [ValProviderConfig!1!ConcurrencyId],          
 Null AS [ValProviderConfig!1!CRMContactId],          
 Null AS [ValProviderConfig!1!UserName],          
 Null AS [ValProviderConfig!1!Password],          
 Null AS [ValProviderConfig!1!ShowHowToScreen],          
 IsNull(A.ClientCount,0) AS [ValProviderConfig!1!ClientCount],     
 IsNull(B.PlanCount,0) AS [ValProviderConfig!1!PlanCount],      
 IsNull(C.PlanCount,0) AS [ValProviderConfig!1!ExcludedPlanCount],  
ISNULL(T1.PasswordEncryption, '') AS [ValProviderConfig!1!PasswordEncryption],        
      
 Case       
 When IsNull(TFirmSch.ValScheduleId, 0) = 0 Then 0      
 When IsNull(TFirmSch.ValScheduleId, 0) <> 0 Then 1      
 End AS [ValProviderConfig!1!IsLocked],      
          
 IsNuLL(CONVERT(varchar(24), TSch.StartDate, 120),'') AS [ValProviderConfig!1!ScheduleValuationStartDate],            
 IsNull(TSch.Frequency,'') AS [ValProviderConfig!1!ScheduleValuationFrequency],            
 IsNull(TSchItemOUT.HasScheduledItems,0) AS [ValProviderConfig!1!HasScheduledItems],          
          
 IsNull(@CertificateId,'') AS [ValProviderConfig!1!CertificateId],          
 IsNull(Convert(varchar(24), @LastCheckedOn, 113),'') AS [ValProviderConfig!1!LastCheckedOn],          
 IsNull(@IsRevoked,'') AS [ValProviderConfig!1!IsRevoked],          
 IsNull(@HasExpired,'') AS [ValProviderConfig!1!HasExpired]          
          
From PolicyManagement.dbo.TValProviderConfig T1 WITH(NOLOCK)   
          
Inner Join PolicyManagement.dbo.TRefProdProvider T2 WITH(NOLOCK)     
On T1.RefProdProviderId = T2.RefProdProviderId  
          
Inner Join CRM.dbo.TCRMContact T3 WITH(NOLOCK)   
On T2.CRMContactId = T3.CRMContactId          
          
Left Join @ClientCountTable A On A.RefProdProviderId = T1.RefProdProviderId              
Left Join @PlanCountTable B On B.RefProdProviderId = T1.RefProdProviderId    
Left Join @ExcludedPlanCountTable C On C.RefProdProviderId = T1.RefProdProviderId         
/*  
Left Join (Select RefProdProviderId, PlanCount = Count(IsNull(PolicyBusinessId,0))            
 From #PlansTable Group By RefProdProviderId) B On B.RefProdProviderId = T1.RefProdProviderId          
*/  
  
      
--Adviser schedule          
Left Join PolicyManagement.dbo.TValSchedule TSch WITH(NOLOCK)   
 On TSch.RefProdProviderId = T1.RefProdProviderId             
 And TSch.ScheduledLevel = 'adviser'            
 And TSch.PortalCRMContactId = @UserCRMContactId -- Added this on 31/08/2006            
      
--Adviser schedule Items            
Left Join             
(Select TSchIN.RefProdProviderId, HasScheduledItems = Count(TSchItemIN.ValScheduleId)            
 From PolicyManagement.dbo.TValSchedule TSchIN WITH(NOLOCK)   
 Left Join PolicyManagement.dbo.TValScheduleItem TSchItemIN WITH(NOLOCK) On TSchIN.ValScheduleId = IsNull(TSchitemIN.ValScheduleId,0)            
 Where IsNull(TSchItemIN.ValScheduleId,0) is Not Null And TSchIN.ScheduledLevel = 'adviser'            
 Group By TSchIN.RefProdProviderId            
) TSchItemOUT On TSchItemOUT.RefProdProviderId = T1.RefProdProviderId           
      
      
--Firm Schedule - to see is firm schedule is on      
Left Join PolicyManagement.dbo.TValSchedule TFirmSch WITH(NOLOCK)   
 On TFirmSch.RefProdProviderId = T1.RefProdProviderId      
 And TFirmSch.IndigoClientId = @IndigoClientId      
 And TFirmSch.ScheduledLevel = 'firm'         
  
Where IsNull(T1.AuthenticationType,0) = 1            
          
          
ORDER BY [ValProviderConfig!1!ProviderName]              
              
FOR XML EXPLICIT  
  
  
GO
