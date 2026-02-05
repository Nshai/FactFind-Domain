SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveScheduleForFirm]        
 @IndigoClientId bigint        
AS    
 
  
/*  
--test    
declare @IndigoClientId bigint        
set @IndigoClientId = 101  
    
drop table #PlansTable    
*/  
  
      
--Select Firm CE enabled providers      
declare @FirmRefProdProviders table (RefprodProviderId bigint)      
      
Insert Into @FirmRefProdProviders      
Select RefProdProviderId       
From PolicyManagement..TValProviderConfig WITH(NOLOCK)      
Where BulkValuationType is not null  
    
  
IF EXISTS (SELECT name FROM sysindexes     
      WHERE name = 'IDX_#PlansTable_PolicyBusinessId')    
DROP INDEX #PolicyBusinessMapping.IDX_#PlansTable_PolicyBusinessId    
  
IF EXISTS (SELECT name FROM sysindexes     
      WHERE name = 'IDX_#PlansTable_RefProdProviderId')    
DROP INDEX #PolicyBusinessMapping.IDX_#PlansTable_RefProdProviderId    
  
IF EXISTS (SELECT name FROM sysindexes     
      WHERE name = 'IDX_#PlansTable_PractitionerCRMContactId')    
DROP INDEX #PolicyBusinessMapping.IDX_#PlansTable_PractitionerCRMContactId  
  
IF EXISTS (SELECT name FROM sysindexes     
      WHERE name = 'IDX_#PlansTable_PractitionerId')    
DROP INDEX #PolicyBusinessMapping.IDX_#PlansTable_PractitionerId  
    
Create Table #PlansTable(              
 Id bigint IDENTITY (1, 1),              
 PolicyBusinessId bigint,              
 RefProdProviderId bigint,              
 --ClientCRMContactId bigint,        
 PractitionerId bigint,  
 PractitionerCRMContactId bigint, --Selling Adviser CRMContactId   
 HasPortalDetails bit  
 )  
  
       
Declare @FirmRecordsExists bit        
        
If Exists (Select 1 from Policymanagement..TValSchedule WITH(NOLOCK) where IndigoClientId = @IndigoClientId and ScheduledLevel = 'firm' )        
 Set @FirmRecordsExists = 1        
else        
 Set @FirmRecordsExists = 0        
        
If @FirmRecordsExists = 1        
Begin        
        
--############################################ Start of Plan Count  #################################################        
      
declare @Inforce_IntelligentOfficeStatusTypeId bigint      
      
Select @Inforce_IntelligentOfficeStatusTypeId = StatusID       
From PolicyManagement..TStatus WITH(NOLOCK)  
Where IndigoClientId = @IndigoClientId And IntelligentOfficeStatusType = 'In force'       
              
              
--Find All inforce plans (filtered by RefProdProviderIs from TValProviderConfig) where the Selling Adviser = @PractitionerId              
Insert Into #PlansTable (PolicyBusinessId, RefProdProviderId, PractitionerId)              
Select T1.PolicyBusinessId, T4.RefProdProviderId, T1.PractitionerId --  , *               
      
From PolicyManagement..TPolicyBusiness T1 WITH(NOLOCK)             
Inner Join PolicyManagement..TPolicyDetail T2 WITH(NOLOCK) On T1.PolicyDetailId = T2.PolicyDetailId --941                  
Inner Join PolicyManagement..TPlanDescription T4 WITH(NOLOCK) On T2.PlanDescriptionId = T4.PlanDescriptionId                 
      
Inner Join PolicyManagement..TValProviderConfig T7 WITH(NOLOCK) On T4.RefProdProviderId = T7.RefProdProviderId              
Inner Join TStatusHistory T8 WITH(NOLOCK) On T1.PolicyBusinessId = T8.PolicyBusinessId AND T8.CurrentStatusFG = 1            
            
--new mapping on gated products - 12/12/2006            
Inner Join PolicyManagement..TRefPlanType2ProdSubType T10 WITH(NOLOCK) On T4.RefPlanType2ProdSubTypeId = T10.RefPlanType2ProdSubTypeId            
Inner Join PolicyManagement..TValGating valgating WITH(NOLOCK)            
 On valgating.RefPlanTypeId = T10.RefPlanTypeId             
 And IsNull(valgating.ProdSubTypeId,0) = IsNull(T10.ProdSubTypeId,0)            
 And valgating.RefProdProviderId = T4.RefProdProviderId            
          
Where T1.IndigoClientId = @IndigoClientId       
And T8.StatusId = @Inforce_IntelligentOfficeStatusTypeId      
And T4.RefProdProviderId in (Select RefProdProviderId from @FirmRefProdProviders)    
--removed 2008-11-13 --And T1.PolicyNumber is not null And len(T1.PolicyNumber)>0          
            
--start new code - insert linked providers   - i.e. plans that map via TValLookup  
Insert Into #PlansTable (PolicyBusinessId, RefProdProviderId, PractitionerId)              
Select T1.PolicyBusinessId, T7.MappedRefProdProviderId, T1.PractitionerId --  , *               
From PolicyManagement..TPolicyBusiness T1 WITH(NOLOCK)        
Inner Join PolicyManagement..TPolicyDetail T2 WITH(NOLOCK) On T1.PolicyDetailId = T2.PolicyDetailId --941                 
Inner Join PolicyManagement..TPlanDescription T4 WITH(NOLOCK) On T2.PlanDescriptionId = T4.PlanDescriptionId                 
     
Inner Join PolicyManagement..TValLookup T7 WITH(NOLOCK) On T4.RefProdProviderId = T7.RefProdProviderId              
Inner Join TStatusHistory T8 WITH(NOLOCK) On T1.PolicyBusinessId = T8.PolicyBusinessId AND T8.CurrentStatusFG = 1            
            
--new mapping on gated products - 12/12/2006            
Inner Join PolicyManagement..TRefPlanType2ProdSubType T10 WITH(NOLOCK)On T4.RefPlanType2ProdSubTypeId = T10.RefPlanType2ProdSubTypeId            
Inner Join PolicyManagement..TValGating valgating WITH(NOLOCK)        
 On valgating.RefPlanTypeId = T10.RefPlanTypeId             
 And IsNull(valgating.ProdSubTypeId,0) = IsNull(T10.ProdSubTypeId,0)            
  And valgating.RefProdProviderId = T7.MappedRefProdProviderId            
            
Where T1.IndigoClientId = @IndigoClientId       
And T8.StatusId = @Inforce_IntelligentOfficeStatusTypeId      
And T7.MappedRefProdProviderId in (Select RefProdProviderId from @FirmRefProdProviders)   
--removed 2008-11-13 -- and T1.PolicyNumber is not null and len(T1.PolicyNumber)>0      
--end new code            
  
--############################################ End of Plan Count  #################################################        
  
        
--############################################ Start of Check Adviser Status #################################################        
  
CREATE INDEX IDX_#PlansTable_PractitionerId ON #PlansTable (PractitionerId)   
  
--Update PractitionerCRMContactId and assume the advisers have access granted   
update A  
Set HasPortalDetails = 1, A.PractitionerCRMContactId = B.CRMContactId  
From #PlansTable A WITH(NOLOCK)  
Inner Join CRM..TPractitioner B WITH(NOLOCK) On A.PractitionerId = B.PractitionerId  
Where B.IndClientId = @IndigoClientId  
  
CREATE INDEX IDX_#PlansTable_PractitionerCRMContactId ON #PlansTable (PractitionerCRMContactId)   
  
--mark records where the user status is like 'Access Denied%'    
update A  
Set HasPortalDetails = 0  
From #PlansTable A WITH(NOLOCK)  
Inner Join Administration..TUser B WITH(NOLOCK) On A.PractitionerCRMContactId = B.crmcontactid  
Where B.IndigoClientId = @IndigoClientId  
And B.Status like 'Access Denied%'  
--############################################ End of Check Adviser Status  #################################################        
        
--Check to see if Portal Details counts are correct        
--select * From #PlansTable where RefProdProviderId in (558, 347) order by RefProdProviderId, Policybusinessid        
--pbid =25859 for 558 should not have portal details        
--return        


--############################################ Start of Adviser Count  #################################################        
/*
--Check total advisers
select count(*) from crm..tpractitioner a with(nolock) 
inner join crm..tcrmcontact b with(nolock) on a.crmcontactid = b.crmcontactid
where b.IndClientId = @IndigoClientId
*/

  
--Count Access Granted Advisers              
Declare @AdviserCount table (RefProdProviderId bigint, AdviserCount bigint)        
        
Insert Into @AdviserCount (RefProdProviderId, AdviserCount)        

Select refprodproviderid, count(*)
from (
Select refprodproviderid--, AdviserPlans = count(refprodproviderid)
From #PlansTable
Where hasportaldetails = 1 
Group By refprodproviderid, practitionerId
) a
group by a.refprodproviderid

/* 
--07/05/2009: Original code changed to above as its counts schedules

Select        
 B.RefProdProviderId, Count(D.UserId)  
From        
 @FirmRefProdProviders A  
 Inner Join PolicyManagement..TValSchedule B WITH(NOLOCK) On A.RefProdProviderId = B.RefProdProviderId  
 Inner Join CRM..TPractitioner C WITH(NOLOCK) On B.IndigoClientId = C.IndClientId        
 Inner Join Administration..TUser D WITH(NOLOCK) On C.CRMContactId = D.CRMContactId  
Where        
 B.IndigoClientId = @IndigoClientId  
 And D.IndigoClientId = @IndigoClientId  
 And D.Status like 'Access Granted%'  
Group By B.RefProdProviderId  
*/        
--############################################ End of Adviser Count  #################################################   



End        

  
--speed up retrieval  
CREATE INDEX IDX_#PlansTable_PolicyBusinessId ON #PlansTable (PolicyBusinessId)    
CREATE INDEX IDX_#PlansTable_RefProdProviderId ON #PlansTable (RefProdProviderId)   
  
        
BEGIN        
        
Select        
 1 AS Tag,        
 NULL AS Parent,        
 IsNull(A.ValScheduleId,'') AS [ValSchedule!1!ValScheduleId],        
 IsNull(A.ScheduledLevel,'') AS [ValSchedule!1!ScheduledLevel],        
 IsNull(A.RefProdProviderId,'') AS [ValSchedule!1!RefProdProviderId],        
 IsNull(C.CorPorateName,'') AS [ValSchedule!1!ProviderName],        
 IsNull(Convert(varchar(24),A.StartDate,120),'') AS [ValSchedule!1!StartDate],        
 IsNull(A.Frequency,'') AS [ValSchedule!1!Frequency],        
 IsNull(A.IsLocked,0) AS [ValSchedule!1!IsLocked],        
 IsNull(D.AdviserCount,0) AS [ValSchedule!1!AdviserCount],        
 IsNull(plans.PlanCount,0) AS [ValSchedule!1!PlanCount],        
 IsNull(canplans.PlanCount,0) AS [ValSchedule!1!PlansThatCanBeScheduled],        
 IsNull(cannotplans.PlanCount,0) AS [ValSchedule!1!PlansThatCannotBeScheduled],        
        
 IsNull(reg.FileAccessCredentialsRequired,0) AS [ValSchedule!1!FileAccessCredentialsRequired],        
    
 Case When IsNull(TSchItem.ValScheduleId,0) <> 0 then 1 else 0 End AS [ValSchedule!1!HasScheduledItems],    
--changed to above -- IsNull(TSchItemOUT.HasScheduledItems,0) AS [ValSchedule!1!HasScheduledItems],        
    
 IsNull(reg.HowToXML,'') AS [ValSchedule!1!HowToXML],    
    
 Case IsNull(TSchItemStat.Identifier, '')    
 When 'DownloadCompleted' Then 'Download Completed'    
 When 'DownloadFailed' Then 'Download Failed'    
 When 'ProcessCompleted' Then 'Process Completed'    
 When 'ProcessFailed' Then 'Process Failed'    
 Else IsNull(TSchItemStat.Identifier, '')    
 End AS [ValSchedule!1!LastSVStatus]    
    
From         
 PolicyManagement..TValSchedule A WITH(NOLOCK)        
        
 --ProviderName        
 Inner Join PolicyManagement..TRefProdProvider B WITH(NOLOCK) On A.RefProdProviderId = B.RefProdProviderId        
 Inner Join CRM..TCRMContact C WITH(NOLOCK) On B.CRMContactId = C.CRMContactId         
        
 --Adviser Count           
 Left Join @AdviserCount D On B.RefProdProviderId = D.RefProdProviderId        
        
 --Plan Count        
 Left Join (Select RefProdProviderId, PlanCount = Count(IsNull(PolicyBusinessId,0))              
  From #PlansTable Group By RefProdProviderId ) plans On plans.RefProdProviderId = A.RefProdProviderId         
        
 --Plan that can be scheduled        
 Left Join (Select RefProdProviderId, PlanCount = Count(IsNull(HasPortalDetails,0))              
  From #PlansTable         
  Where IsNull(HasPortalDetails,0) = 1        
  Group By RefProdProviderId ) canplans On canplans.RefProdProviderId = A.RefProdProviderId         
        
 --Plan that cannot be scheduled        
 Left Join (Select RefProdProviderId, PlanCount = Count(IsNull(HasPortalDetails,0))              
  From #PlansTable         
  Where IsNull(HasPortalDetails,0) = 0        
  Group By RefProdProviderId ) cannotplans On cannotplans.RefProdProviderId = A.RefProdProviderId        
        
 --Registration Process        
 Left Join PolicyManagement..TValProviderConfig reg WITH(NOLOCK) On A.RefProdProviderId = reg.RefProdProviderId        
        
 --Has Scheduled Item - for RT - TO DO when required        
 --TValSchedule & TValScheduleItem        
 Left Join PolicyManagement.dbo.TValScheduleItem TSchItem WITH(NOLOCK)     
 On A.ValScheduleId = IsNull(TSchItem.ValScheduleId,0)    
 And TSchItem.NextOccurrence is Not Null     
    
--original changed to above    
/*         
 (        
  Select TSchIN.RefProdProviderId, HasScheduledItems = Count(TSchItemIN.ValScheduleId)              
  From PolicyManagement.dbo.TValSchedule TSchIN WITH(NOLOCK)             
  Left Join PolicyManagement.dbo.TValScheduleItem TSchItemIN WITH(NOLOCK) On TSchIN.ValScheduleId = IsNull(TSchitemIN.ValScheduleId,0)              
  Where TSchItemIN.ValScheduleId is Not Null         
   And TSchItemIN.NextOccurrence is Not Null        
   And TSchIN.ScheduledLevel = 'firm'              
  Group By TSchIN.RefProdProviderId        
 )        
 TSchItemOUT On TSchItemOUT.RefProdProviderId = A.RefProdProviderId         
*/    
    
--new 20080625 -     
Left Join PolicyManagement.dbo.TRefValScheduleItemStatus TSchItemStat WITH(NOLOCK)    
 On TSchItem.RefValScheduleItemStatusId = TSchItemStat.RefValScheduleItemStatusId    
        
Where         
 A.IndigoClientId = @IndigoClientId        
 And A.ScheduledLevel = 'firm'        
       
FOR XML EXPLICIT        
        
END        
Return(0)



GO
