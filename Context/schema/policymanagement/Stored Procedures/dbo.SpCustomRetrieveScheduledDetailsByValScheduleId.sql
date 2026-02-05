SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveScheduledDetailsByValScheduleId] @ValScheduleId bigint  
AS          
    
       
--declare @NextOccurrence datetime              
--set @NextOccurrence = '2008-03-17'  
        
--internal prams             
declare @RefProdProviderIds varchar(1000), @IndigoClientIds varchar(1000)          
--drop table #DataTable           
--drop table #PlansTable            

exec dbo.SpNioCustomOpenSymmetricKeyForPasswordEncryption

create table #DataTable (IndigoClientId bigint, RefProdProviderId bigint, PractitionerId bigint, ScheduledLevel varchar(255))            
            
            
--Return reference data from all scheduled items          
Insert into #DataTable (IndigoClientId, RefProdProviderId, PractitionerId, ScheduledLevel)            
Select T1.IndigoClientId, T1.RefProdProviderId, IsNull(T3.PractitionerId,0), T1.ScheduledLevel            
From PolicyManagement..TValSchedule T1 WITH(NOLOCK)        
Inner Join PolicyManagement..TValScheduleItem T2 WITH(NOLOCK) ON T1.ValScheduleId = T2.ValScheduleId            
Left Join CRM..TPractitioner T3 WITH(NOLOCK) ON IsNull(T1.PortalCRMContactId,0) = T3.CRMContactId            
Where             
T2.ValScheduleId = @ValScheduleId  
     
            
--Test Line            
--select * from #DataTable            
--*return            
            
--Firm plans            
--set @IndigoClientId = 14                  
--set @RefProdProviderIds = '558,'            
                
                 
--############################################ Start of Plan Count  #################################################            
             
Create Table #PlansTable(                    
 Id bigint IDENTITY (1, 1),            
 IndigoClientId bigint,             
 PolicyBusinessId bigint,                  
 RefProdProviderId bigint,                  
 ClientCRMContactId bigint,            
 PractitionerId bigint,            
 PractitionerCRMContactId bigint, --Selling Adviser CRMContactId            
 HasPortalDetails bit,            
 ScheduledLevel varchar(255)            
 )                  
                  
  
If Exists(select 1 from #DataTable where ScheduledLevel = 'adviser')   
Begin  
  
 --Find All inforce plans with PolicyNumbers (filtered by RefProdProviderIs from TValProviderConfig) mapping on Selling Adviser = @PractitionerId and RefProdProvider                  
 Insert Into #PlansTable (IndigoClientId, PolicyBusinessId, RefProdProviderId, ClientCRMContactId, PractitionerId, ScheduledLevel)                  
 Select T1.IndigoClientId, T1.PolicyBusinessId, T5.RefProdProviderId, ClientCRMContactId = T3.CRMContactId, T1.PractitionerId, 'adviser' --  , *                   
 From PolicyManagement..TPolicyBusiness T1 WITH(NOLOCK)                 
 Inner Join PolicyManagement..TPolicyDetail T2 WITH(NOLOCK) On T1.PolicyDetailId = T2.PolicyDetailId --941                  
 Inner Join PolicyManagement..TPolicyOwner T3 WITH(NOLOCK) On T2.PolicyDetailId = T3.PolicyDetailId                  
 Inner Join PolicyManagement..TPlanDescription T4 WITH(NOLOCK) On T2.PlanDescriptionId = T4.PlanDescriptionId                     
 Inner Join PolicyManagement..TRefProdProvider T5 WITH(NOLOCK) On T4.RefProdProviderId = T5.RefProdProviderId                  
 Inner Join PolicyManagement..TValProviderConfig T7 WITH(NOLOCK) On T5.RefProdProviderId = T7.RefProdProviderId                  
                   
 Inner Join TStatusHistory T8 WITH(NOLOCK) On T1.PolicyBusinessId = T8.PolicyBusinessId AND T8.CurrentStatusFG = 1                
 Inner Join TStatus T9 WITH(NOLOCK) On T8.StatusId = T9.StatusId                
  AND T9.IntelligentOfficeStatusType = 'In force'                
               
                 
 --new mapping on gated products - 12/12/2006                
 Inner Join PolicyManagement..TRefPlanType2ProdSubType T10 WITH(NOLOCK) On T4.RefPlanType2ProdSubTypeId = T10.RefPlanType2ProdSubTypeId             
 Inner Join PolicyManagement..TValGating valgating WITH(NOLOCK)                
  On valgating.RefPlanTypeId = T10.RefPlanTypeId                 
  And IsNull(valgating.ProdSubTypeId,0) = IsNull(T10.ProdSubTypeId,0)                
  And valgating.RefProdProviderId = T5.RefProdProviderId                
                 
 Where T1.PractitionerId in (Select PractitionerId From #DataTable Where ScheduledLevel = 'adviser')            
 And T5.RefProdProviderId in (Select RefProdProviderId From #DataTable Where ScheduledLevel = 'adviser')  --get results for selected providers only            
 And IsNull(T1.PolicyNumber,'') <> ''             
             
               
 --start new code - insert lookup clients - i.e. plans/clients that map to TValLookup - linked providers            
 Insert Into #PlansTable (IndigoClientId, PolicyBusinessId, RefProdProviderId, ClientCRMContactId,  PractitionerId, ScheduledLevel)                  
 Select T1.IndigoClientId, T1.PolicyBusinessId, T5.RefProdProviderId, ClientCRMContactId = T3.CRMContactId,  T1.PractitionerId, 'adviser' --  , *                   
 From PolicyManagement..TPolicyBusiness T1 WITH(NOLOCK)            
 Inner Join PolicyManagement..TPolicyDetail T2 WITH(NOLOCK) On T1.PolicyDetailId = T2.PolicyDetailId --941                  
 Inner Join PolicyManagement..TPolicyOwner T3 WITH(NOLOCK) On T2.PolicyDetailId = T3.PolicyDetailId                  
 Inner Join PolicyManagement..TPlanDescription T4 WITH(NOLOCK) On T2.PlanDescriptionId = T4.PlanDescriptionId                     
 Inner Join PolicyManagement..TRefProdProvider T5 WITH(NOLOCK) On T4.RefProdProviderId = T5.RefProdProviderId                  
                 
 Inner Join PolicyManagement..TValLookup T7 WITH(NOLOCK) On T5.RefProdProviderId = T7.RefProdProviderId                  
                 
 Inner Join TStatusHistory T8 WITH(NOLOCK) On T1.PolicyBusinessId = T8.PolicyBusinessId AND T8.CurrentStatusFG = 1                
 Inner Join TStatus T9 WITH(NOLOCK) On T8.StatusId = T9.StatusId                
  AND T9.IntelligentOfficeStatusType = 'In force'                
             
                 
 --new mapping on gated products - 12/12/2006                
 Inner Join PolicyManagement..TRefPlanType2ProdSubType T10 WITH(NOLOCK)On T4.RefPlanType2ProdSubTypeId = T10.RefPlanType2ProdSubTypeId                
 Inner Join PolicyManagement..TValGating valgating WITH(NOLOCK)            
  On valgating.RefPlanTypeId = T10.RefPlanTypeId                 
  And IsNull(valgating.ProdSubTypeId,0) = IsNull(T10.ProdSubTypeId,0)                
   And valgating.RefProdProviderId = T7.MappedRefProdProviderId                
             
 Where T1.PractitionerId in (Select PractitionerId From #DataTable Where ScheduledLevel = 'adviser')            
 And T5.RefProdProviderId in (Select RefProdProviderId From #DataTable Where ScheduledLevel = 'adviser')  --get results for selected providers only            
 And IsNull(T1.PolicyNumber,'') <> ''             
 --end new code                
             
               
                 
 --start new code - update lookup.refproviderid to TValProviderConfig.refproviderid                
 update #PlansTable                
 set RefProdProviderId = OriginalId                
 from                 
 (                
 Select OriginalId = a.RefProdProviderId, lookupId = b.RefProdProviderId                 
 From PolicyManagement..TValProviderConfig A                
 Inner Join PolicyManagement..TValLookup b on b.MappedRefProdProviderId = A.RefProdProviderId                
 ) b                
 where RefProdProviderId = lookupId                
 --end new code               
             
 --############################################ End of Plan Count  #################################################            
         
         
         
 --############################################ Start Wrapper Providers counts  #################################################            
         
 --Insert Wrapper Providers counts - Ignore In-Force rule        
 Insert Into #PlansTable (PolicyBusinessId, RefProdProviderId, ClientCRMContactId)                  
 Select T1.PolicyBusinessId, T5.RefProdProviderId, ClientCRMContactId = T3.CRMContactId --  , *                   
 From PolicyManagement..TPolicyBusiness T1 WITH(NOLOCK)                  
 Inner Join PolicyManagement..TPolicyDetail T2 WITH(NOLOCK) On T1.PolicyDetailId = T2.PolicyDetailId --941                  
 Inner Join PolicyManagement..TPolicyOwner T3 WITH(NOLOCK) On T2.PolicyDetailId = T3.PolicyDetailId                  
 Inner Join PolicyManagement..TPlanDescription T4 WITH(NOLOCK) On T2.PlanDescriptionId = T4.PlanDescriptionId                     
 Inner Join PolicyManagement..TRefProdProvider T5 WITH(NOLOCK) On T4.RefProdProviderId = T5.RefProdProviderId                  
 Inner Join PolicyManagement..TValProviderConfig T7 WITH(NOLOCK) On T5.RefProdProviderId = T7.RefProdProviderId                  
         
 Inner Join PolicyManagement.dbo.TValGating valgating WITH(NOLOCK)           
 On valgating.RefProdProviderId = T7.RefProdProviderId            
         
 --wrapper provider and plan types        
 Inner Join PolicyManagement..TWrapperProvider wp WITH(NOLOCK)        
 On wp.RefProdProviderId = T7.RefProdProviderId And wp.RefPlanTypeId = valgating.RefPlanTypeId        
         
 Where T1.IndigoClientId in (Select IndigoClientId From #DataTable Where ScheduledLevel = 'adviser')            
 And T5.RefProdProviderId in (Select RefProdProviderId From #DataTable Where ScheduledLevel = 'adviser')  --get results for selected providers only            
 And IsNull(T1.PolicyNumber,'') <> ''          
 --############################################ End Wrapper Providers counts  #################################################            
  
 --select *from #PlansTable  
 --return  
             
 /*test          
 select a.PolicyBusinessId, b.PolicyBusinessId, a.*          
 From          
 PolicyManagement..TValSchedulePolicy a          
 Left Join #PlansTable b on a.PolicyBusinessId = b.PolicyBusinessId           
 where a.policybusinessid  = 600175          
           
 return          
 */          
             
 --############################################ Start of Check Portal Details  #################################################            
             
 --check plans against TCertificate credentials            
 update #PlansTable            
 set HasPortalDetails = 1, PractitionerCRMContactId = lookupPractitionerCRMContactId            
 from             
 (            
 Select lookupRefProdProviderId = C.RefProdProviderId, lookupPractitionerId = B.PractitionerId, D.AuthenticationType, lookupPractitionerCRMContactId = B.CRMContactId            
 From  Administration..TCertificate A WITH(NOLOCK)              
 Inner Join CRM..TPractitioner B WITH(NOLOCK) On A.CRMContactId = B.CRMContactId            
 Inner Join #PlansTable C WITH(NOLOCK) On B.PractitionerId = C.PractitionerId            
 Inner Join PolicyManagement..TValProviderConfig D WITH(NOLOCK) On C.RefProdProviderId = D.RefProdProviderId            
 ) lookup            
 where RefProdProviderId = lookupRefProdProviderId And PractitionerId = lookupPractitionerId And AuthenticationType = 1            
             
             
 --check plans against TValPortalSetUp credentials            
 update #PlansTable            
 set HasPortalDetails = 1, PractitionerCRMContactId = lookupPractitionerCRMContactId            
 from             
 (            
 Select lookupRefProdProviderId = C.RefProdProviderId, lookupPractitionerId = B.PractitionerId, D.AuthenticationType, lookupPractitionerCRMContactId = B.CRMContactId            
 From  PolicyManagement..TValPortalSetUp A WITH(NOLOCK)             
 Inner Join CRM..TPractitioner B WITH(NOLOCK) On B.CRMContactId = A.CRMContactId            
 Inner Join #PlansTable C WITH(NOLOCK) On C.PractitionerId = B.PractitionerId            
 Inner Join PolicyManagement..TValProviderConfig D WITH(NOLOCK) On D.RefProdProviderId = C.RefProdProviderId            
 ) lookup            
 where RefProdProviderId = lookupRefProdProviderId And PractitionerId = lookupPractitionerId And AuthenticationType = 0            
         
 --############################################ End of Check Portal Details  #################################################            
       
 --Check to see if Portal Details counts are correct            
 --select * From #PlansTable where RefProdProviderId in (558, 347) order by RefProdProviderId, Policybusinessid            
 ----pbid =25859 for 558 should not have portal details            
           
 --select * From #PlansTable          
 --return            
       
       
 --Delete duplicate policybusinessid due joint client      
 delete from #PlansTable      
 where id in (          
  select max(id)--, policybusinessid, count(*)       
  From #PlansTable          
  group by policybusinessid       
  having count(*) > 1      
 )  
  
End  
          
          
----------------------------------------            
            
--MAIN SELECT            
SELECT              
 1 AS Tag,              
 NULL AS Parent,              
 IsNull(T1.ValScheduleId,0) AS [ValSchedule!1!ValScheduleId],              
 IsNull(T1.Guid,'') AS [ValSchedule!1!Guid],              
 IsNull(T1.ScheduledLevel,'') AS [ValSchedule!1!ScheduledLevel],              
 Case             
  When IsNull(T1.ScheduledLevel,'') = 'client' Then 1            
  When IsNull(T1.ScheduledLevel,'') = 'firm' Then 2            
  When IsNull(T1.ScheduledLevel,'') = 'adviser' Then 3            
 End            
 AS [ValSchedule!1!ProcessOrder],            
 IsNull(T1.IndigoClientId,0) AS [ValSchedule!1!IndigoClientId],              
 IsNull(IC.FSA ,'') AS [ValSchedule!1!IndigoClientFSA],              
 IsNull(G.FSARegNbr,'') AS [ValSchedule!1!GroupFSA],              
 IsNull(T1.RefProdProviderId,0) AS [ValSchedule!1!RefProdProviderId],              
 IsNull(T1.ClientCRMContactId,0) AS [ValSchedule!1!ClientCRMContactId],              
 IsNull(T1.UserCredentialOption,'') AS [ValSchedule!1!UserCredentialOption],              
 IsNull(T1.PortalCRMContactId,0) AS [ValSchedule!1!PortalCRMContactId],              
 IsNull(T3.UserId,0) AS [ValSchedule!1!UserId],              
 IsNull(CONVERT(varchar(24), T1.StartDate, 120),'') AS [ValSchedule!1!StartDate],              
 IsNull(T1.Frequency,'') AS [ValSchedule!1!Frequency],              
 IsNull(T1.IsLocked,0) AS [ValSchedule!1!IsLocked],              
 IsNull(T1.UserNameForFileAccess,'') AS [ValSchedule!1!UserNameForFileAccess],              
 IsNull(dbo.FnCustomDecryptPortalPassword(T1.Password2ForFileAccess),'') AS [ValSchedule!1!PasswordForFileAccess],
 IsNull(T4.BulkValuationType,'') AS [ValSchedule!1!BulkValuationType],              
 IsNull(T4.ScheduleDelay,0) AS [ValSchedule!1!ScheduleDelay],              
        
 --If no provider hours of operation defined, assume not available - i.e. can't request a valuation        
 IsNull(T5.AlwaysAvailableFg,0) AS [ValSchedule!1!AlwaysAvailableFg],      
 IsNull(T5.DayOfTheWeek,'') AS [ValSchedule!1!DayOfTheWeek],      
 IsNull(T5.StartHour,0) AS [ValSchedule!1!StartHour],      
 IsNull(T5.EndHour,0) AS [ValSchedule!1!EndHour],      
 IsNull(T5.StartMinute,0) AS [ValSchedule!1!StartMinute],      
 IsNull(T5.EndMinute,0) AS [ValSchedule!1!EndMinute],      
  
 --need this as the new code works off a scratch table  
 0 AS [ValSchedule!1!IsProcessed],      
 convert(varchar(24),DateAdd(s,10,Getdate()),120) AS [ValSchedule!1!SubmitAtOrAfter],      
  
            
 NULL AS [ValScheduleItem!2!ValScheduleItemId],      
 NULL AS [ValScheduleItem!2!ValScheduleId],      
 NULL AS [ValScheduleItem!2!ValQueueId],      
 NULL AS [ValScheduleItem!2!NextOccurrence],      
 NULL AS [ValScheduleItem!2!LastOccurrence],      
 NULL AS [ValScheduleItem!2!RefValScheduleItemStatusId],      
 NULL AS [ValScheduleItem!2!SaveAsFilePathAndName],      
NULL AS [ValScheduleItem!2!DocVersionId],      
 NULL AS [ValSchedulePolicy!3!ValScheduleId],      
 NULL AS [ValSchedulePolicy!3!RefProdProviderId],      
 NULL AS [ValSchedulePolicy!3!ClientCRMContactId],      
 NULL AS [ValSchedulePolicy!3!PolicyBusinessId],      
 NULL AS [ValSchedulePolicy!3!UserCredentialOption],      
 NULL AS [ValSchedulePolicy!3!PortalCRMContactId],      
 NULL AS [ValSchedulePolicy!3!ScheduledLevel]      
            
FROM PolicyManagement..TValSchedule T1 WITH(NOLOCK)              
INNER JOIN PolicyManagement..TValScheduleItem T2 WITH(NOLOCK) ON T1.ValScheduleId = T2.ValScheduleId        
INNER JOIN PolicyManagement..TValProviderConfig T4 WITH(NOLOCK) ON T1.RefProdProviderId = T4.RefProdProviderId        
LEFT JOIN Administration..TUser T3 WITH(NOLOCK) On T3.CRMContactId = T1.PortalCRMContactId        
        
--Hours of Operation        
LEFT JOIN PolicyManagement..TValProviderHoursOfOperation T5 WITH(NOLOCK) ON T1.RefProdProviderId = T5.RefProdProviderId        
 And LOWER(DATENAME(dw, GETDATE())) = IsNull(T5.DayOfTheWeek, LOWER(DATENAME(dw, GETDATE())))        

--Company FSA 
LEFT JOIN Administration..TIndigoclient IC on T1.IndigoClientID = IC.IndigoClientID

--Group FSA
LEFT JOIN administration..TGroup G on g.GroupId = T1.RefGroupId
        
WHERE          
T1.ValScheduleId = @ValScheduleId  
And T1.Islocked = 0      
        
              
UNION ALL              
              
SELECT              
 2 AS Tag,              
 1 AS Parent,              
 IsNull(T1.ValScheduleId,0) AS [ValSchedule!1!ValScheduleId],              
 IsNull(T1.Guid,'') AS [ValSchedule!1!Guid],              
 IsNull(T1.ScheduledLevel,'') AS [ValSchedule!1!ScheduledLevel],              
 Case             
  When IsNull(T1.ScheduledLevel,'') = 'client' Then 1            
  When IsNull(T1.ScheduledLevel,'') = 'firm' Then 2            
  When IsNull(T1.ScheduledLevel,'') = 'adviser' Then 3            
 End            
 AS [ValSchedule!1!ProcessOrder],            
 Null,      
 Null,       
 Null,
 Null,
 Null,      
 Null,      
 Null,      
 Null,      
 Null,      
 Null,      
 Null,      
 Null,      
 Null,      
 Null,      
 Null,    
        
 Null,      
 Null,      
 Null,      
 Null,      
 Null,      
 Null,      
  
 --need this as the new code works off a scratch table  
 0 AS [ValSchedule!1!IsProcessed],      
 convert(varchar(24),DateAdd(s,10,Getdate()),120) AS [ValSchedule!1!SubmitAtOrAfter],      
             
 IsNull(T2.ValScheduleItemId,0),      
 IsNull(T2.ValScheduleId,0),      
 IsNull(T2.ValQueueId,0),      
 IsNull(CONVERT(varchar(24), T2.NextOccurrence, 120),''),      
 IsNull(CONVERT(varchar(24), T2.LastOccurrence, 120),''),      
 IsNull(T2.RefValScheduleItemStatusId,0) AS [ValScheduleItem!2!RefValScheduleItemStatusId],      
 IsNull(T2.SaveAsFilePathAndName, '') AS [ValScheduleItem!2!SaveAsFilePathAndName],       
 IsNull(T2.DocVersionId, '') AS [ValScheduleItem!2!DocVersionId],       
  NULL AS [ValSchedulePolicy!3!ValScheduleId],      
 NULL AS [ValSchedulePolicy!3!RefProdProviderId],      
 NULL AS [ValSchedulePolicy!3!ClientCRMContactId],      
 NULL AS [ValSchedulePolicy!3!PolicyBusinessId],      
 NULL AS [ValSchedulePolicy!3!UserCredentialOption],      
 NULL AS [ValSchedulePolicy!3!PortalCRMContactId],      
 NULL AS [ValSchedulePolicy!3!ScheduledLevel]      
            
FROM PolicyManagement..TValScheduleItem T2 WITH(NOLOCK)         
INNER JOIN PolicyManagement..TValSchedule T1 WITH(NOLOCK) ON T2.ValScheduleId = T1.ValScheduleId            
WHERE      
T1.Islocked = 0      
And T1.ValScheduleId = @ValScheduleId  
          
          
UNION ALL              
            
            
--Client Plans            
SELECT              
 3 AS Tag,              
 2 AS Parent,              
 IsNull(T1.ValScheduleId,0) AS [ValSchedule!1!ValScheduleId],              
 IsNull(T1.Guid,'') AS [ValSchedule!1!Guid],              
 IsNull(T1.ScheduledLevel,'') AS [ValSchedule!1!ScheduledLevel],              
 Case             
  When IsNull(T1.ScheduledLevel,'') = 'client' Then 1            
  When IsNull(T1.ScheduledLevel,'') = 'firm' Then 2            
  When IsNull(T1.ScheduledLevel,'') = 'adviser' Then 3            
 End            
 AS [ValSchedule!1!ProcessOrder],            
 Null,      
 Null,       
 Null,
 Null,       
 Null,      
 Null,      
 Null,      
 Null,      
 Null,      
 Null,      
 Null,      
 Null,      
 Null,      
 Null,    
 Null,      
      
 Null,      
 Null,      
 Null,      
 Null,      
 Null,      
 Null,      
  
 --need this as the new code works off a scratch table  
 0 AS [ValSchedule!1!IsProcessed],      
 convert(varchar(24),DateAdd(s,10,Getdate()),120) AS [ValSchedule!1!SubmitAtOrAfter],      
             
 IsNull(T2.ValScheduleItemId,0),      
 IsNull(T2.ValScheduleId,0),      
 IsNull(T2.ValQueueId,0),      
 IsNull(CONVERT(varchar(24), T2.NextOccurrence, 120),''),      
 IsNull(CONVERT(varchar(24), T2.LastOccurrence, 120),''),      
 IsNull(T2.RefValScheduleItemStatusId,0) AS [ValScheduleItem!2!RefValScheduleItemStatusId],      
 IsNull(T2.SaveAsFilePathAndName, '') AS [ValScheduleItem!2!SaveAsFilePathAndName],       
 IsNull(T2.DocVersionId, '') AS [ValScheduleItem!2!DocVersionId],                   
 IsNull(T3.ValScheduleId,0) AS [ValSchedulePolicy!3!ValScheduleId],      
 IsNull(T1.RefProdProviderId,0) AS [ValSchedulePolicy!3!RefProdProviderId],      
 IsNull(T1.ClientCRMContactId,0) AS [ValSchedulePolicy!3!ClientCRMContactId],      
 IsNull(T3.PolicyBusinessId,0) AS [ValSchedulePolicy!3!PolicyBusinessId],      
 IsNull(T1.UserCredentialOption,'') AS [ValSchedulePolicy!3!UserCredentialOption],      
 IsNull(T1.PortalCRMContactId,0) AS [ValSchedulePolicy!3!PortalCRMContactId], --based on UserCredentialOption            
 IsNull(T1.ScheduledLevel,'') AS [ValSchedulePolicy!3!ScheduledLevel]      
            
FROM PolicyManagement..TValSchedulePolicy T3 WITH(NOLOCK)         
INNER JOIN PolicyManagement..TValScheduleItem T2 WITH(NOLOCK) ON T3.ValScheduleId = T2.ValScheduleId            
INNER JOIN PolicyManagement..TValSchedule T1 WITH(NOLOCK) ON T2.ValScheduleId = T1.ValScheduleId            
WHERE       
T1.ScheduledLevel = 'client'       
And T1.ValScheduleId = @ValScheduleId  
           
            
UNION ALL              
            
            
--Firm Plans            
SELECT  distinct            
 3 AS Tag,              
 2 AS Parent,              
 IsNull(T2.ValScheduleId,0) AS [ValSchedule!1!ValScheduleId],              
 IsNull(T2.Guid,'') AS [ValSchedule!1!Guid],              
 IsNull(T2.ScheduledLevel,'') AS [ValSchedule!1!ScheduledLevel],              
 Case             
  When IsNull(T2.ScheduledLevel,'') = 'client' Then 1            
  When IsNull(T2.ScheduledLevel,'') = 'firm' Then 2            
  When IsNull(T2.ScheduledLevel,'') = 'adviser' Then 3            
 End            
 AS [ValSchedule!1!ProcessOrder],            
 Null,            
 Null,            
 Null,       
 Null,
 Null,            
 Null,            
 Null,            
 Null,            
 Null,            
 Null,            
 Null,            
 Null,            
 Null,            
 Null,    
 Null,            
        
 Null,            
 Null,            
 Null,            
 Null,            
 Null,            
 Null,            
  
 --need this as the new code works off a scratch table  
 0 AS [ValSchedule!1!IsProcessed],      
 convert(varchar(24),DateAdd(s,10,Getdate()),120) AS [ValSchedule!1!SubmitAtOrAfter],      
             
 IsNull(T3.ValScheduleItemId,0),      
 IsNull(T3.ValScheduleId,0),      
 IsNull(T3.ValQueueId,0),      
 IsNull(CONVERT(varchar(24), T3.NextOccurrence, 120),''),      
 IsNull(CONVERT(varchar(24), T3.LastOccurrence, 120),''),      
 IsNull(T3.RefValScheduleItemStatusId,0) AS [ValScheduleItem!2!RefValScheduleItemStatusId],      
 IsNull(T3.SaveAsFilePathAndName, '') AS [ValScheduleItem!2!SaveAsFilePathAndName],       
IsNull(T3.DocVersionId, '') AS [ValScheduleItem!2!DocVersionId],                   
 IsNull(T2.ValScheduleId,0) AS [ValSchedulePolicy!3!ValScheduleId],               
 IsNull(T1.RefProdProviderId,0) AS [ValSchedulePolicy!3!RefProdProviderId],                  
 IsNull(T1.ClientCRMContactId,0) AS [ValSchedulePolicy!3!ClientCRMContactId],                  
 IsNull(T1.PolicyBusinessId,0) AS [ValSchedulePolicy!3!PolicyBusinessId],                  
 IsNull(T2.UserCredentialOption,'') AS [ValSchedulePolicy!3!UserCredentialOption],            
 IsNull(T1.PractitionerCRMContactId,0) AS [ValSchedulePolicy!3!PortalCRMContactId], --Selling Adviser CRMContactId            
 IsNull(T2.ScheduledLevel,'') AS [ValSchedulePolicy!3!ScheduledLevel]            
            
From #PlansTable T1 WITH(NOLOCK)         
Left Join PolicyManagement..TValSchedule T2 WITH(NOLOCK) On T1.RefProdProviderId = T2.RefProdProviderId And T1.ScheduledLevel = T2.ScheduledLevel            
Left Join PolicyManagement..TValScheduleItem T3 WITH(NOLOCK) ON T2.ValScheduleId = T3.ValScheduleId            
Left Join PolicyManagement..TValProviderConfig T4 WITH(NOLOCK) On T1.RefProdProviderId = T4.RefProdProviderId             
Where       
T2.Islocked = 0      
And T1.PractitionerCRMContactId is Not Null            
And T2.ScheduledLevel = 'firm'            
--Only return policies if the schedule for firm is rt: for file based the policy are picked up via AddPlansDetailsForFirmAndProvider            
And lower(IsNull(T4.BulkValuationType,'')) = lower('RT')            
And T2.ValScheduleId = @ValScheduleId  
          
            
UNION ALL              
            
            
--adviser Plans - pre 17/09/2007 where clientcrmcontact was stored at adviser level          
SELECT  distinct            
 3 AS Tag,              
 2 AS Parent,              
 IsNull(T2.ValScheduleId,0) AS [ValSchedule!1!ValScheduleId],              
 IsNull(T2.Guid,'') AS [ValSchedule!1!Guid],              
 IsNull(T2.ScheduledLevel,'') AS [ValSchedule!1!ScheduledLevel],              
 Case             
  When IsNull(T2.ScheduledLevel,'') = 'client' Then 1            
  When IsNull(T2.ScheduledLevel,'') = 'firm' Then 2            
  When IsNull(T2.ScheduledLevel,'') = 'adviser' Then 3            
 End            
 AS [ValSchedule!1!ProcessOrder],            
 Null,            
 Null,            
 Null,            
 Null,       
 Null,           
 Null,            
 Null,            
 Null,          
 Null,  
 Null,            
 Null,            
 Null,            
 Null,            
 Null,    
 Null,            
        
 Null,            
 Null,            
 Null,            
 Null,            
 Null,            
 Null,            
  
 --need this as the new code works off a scratch table  
 0 AS [ValSchedule!1!IsProcessed],      
 convert(varchar(24),DateAdd(s,10,Getdate()),120) AS [ValSchedule!1!SubmitAtOrAfter],      
             
 IsNull(T3.ValScheduleItemId,0),      
 IsNull(T3.ValScheduleId,0),      
 IsNull(T3.ValQueueId,0),      
 IsNull(CONVERT(varchar(24), T3.NextOccurrence, 120),''),      
 IsNull(CONVERT(varchar(24), T3.LastOccurrence, 120),''),       
 IsNull(T3.RefValScheduleItemStatusId,0) AS [ValScheduleItem!2!RefValScheduleItemStatusId],      
 IsNull(T3.SaveAsFilePathAndName, '') AS [ValScheduleItem!2!SaveAsFilePathAndName],       
IsNull(T3.DocVersionId, '') AS [ValScheduleItem!2!DocVersionId],                   
 IsNull(T2.ValScheduleId,0) AS [ValSchedulePolicy!3!ValScheduleId],               
 IsNull(T1.RefProdProviderId,0) AS [ValSchedulePolicy!3!RefProdProviderId],                  
 IsNull(T1.ClientCRMContactId,0) AS [ValSchedulePolicy!3!ClientCRMContactId],                  
 IsNull(T1.PolicyBusinessId,0) AS [ValSchedulePolicy!3!PolicyBusinessId],                  
 IsNull(T2.UserCredentialOption,'') AS [ValSchedulePolicy!3!UserCredentialOption],            
 IsNull(T1.PractitionerCRMContactId,0) AS [ValSchedulePolicy!3!PortalCRMContactId], --Selling Adviser CRMContactId            
 IsNull(T2.ScheduledLevel,'') AS [ValSchedulePolicy!3!ScheduledLevel]            
          
From          
PolicyManagement..TValSchedule T2 WITH(NOLOCK)         
Inner Join PolicyManagement..TValScheduleItem T3 WITH(NOLOCK) ON T2.ValScheduleId = T3.ValScheduleId          
Inner Join PolicyManagement..TValSchedulePolicy T5 WITH(NOLOCK) ON T2.ValScheduleId = T5.ValScheduleId          
Inner Join #PlansTable T1 WITH(NOLOCK) On T1.PolicyBusinessId = T5.PolicyBusinessId           
 And T1.ScheduledLevel = T2.ScheduledLevel And T2.PortalCRMContactId = T1.PractitionerCRMContactId          
 And IsNull(T2.ClientCRMContactId,0) = T1.ClientCRMContactId          
          
Where           
T2.Islocked = 0      
And T1.PractitionerCRMContactId is Not Null            
And T2.ScheduledLevel = 'adviser'      
And T2.ValScheduleId = @ValScheduleId  
And T2.ClientCRMContactId is not Null          
        
          
UNION ALL              
            
            
--adviser Plans - post 17/09/2007 where clientcrmcontact is NOT stored at adviser level          
SELECT  distinct            
 3 AS Tag,              
 2 AS Parent,              
 IsNull(T2.ValScheduleId,0) AS [ValSchedule!1!ValScheduleId],              
 IsNull(T2.Guid,'') AS [ValSchedule!1!Guid],              
 IsNull(T2.ScheduledLevel,'') AS [ValSchedule!1!ScheduledLevel],              
 Case             
When IsNull(T2.ScheduledLevel,'') = 'client' Then 1            
  When IsNull(T2.ScheduledLevel,'') = 'firm' Then 2            
  When IsNull(T2.ScheduledLevel,'') = 'adviser' Then 3            
 End            
 AS [ValSchedule!1!ProcessOrder],            
 Null,            
 Null,            
 Null,            
 Null,       
 Null,            
 Null,
 Null,            
 Null,            
 Null,            
 Null,            
 Null,            
 Null,            
 Null,            
 Null,    
 Null,    
        
 Null,            
 Null,            
 Null,            
 Null,            
 Null,            
 Null,            
  
 --need this as the new code works off a scratch table  
 0 AS [ValSchedule!1!IsProcessed],      
 convert(varchar(24),DateAdd(s,10,Getdate()),120) AS [ValSchedule!1!SubmitAtOrAfter],      
             
 IsNull(T3.ValScheduleItemId,0),      
 IsNull(T3.ValScheduleId,0),      
 IsNull(T3.ValQueueId,0),      
 IsNull(CONVERT(varchar(24), T3.NextOccurrence, 120),''),      
 IsNull(CONVERT(varchar(24), T3.LastOccurrence, 120),''),      
 IsNull(T3.RefValScheduleItemStatusId,0) AS [ValScheduleItem!2!RefValScheduleItemStatusId],      
 IsNull(T3.SaveAsFilePathAndName, '') AS [ValScheduleItem!2!SaveAsFilePathAndName],       
 IsNull(T3.DocVersionId, '') AS [ValScheduleItem!2!DocVersionId],                   
 IsNull(T2.ValScheduleId,0) AS [ValSchedulePolicy!3!ValScheduleId],               
 IsNull(T1.RefProdProviderId,0) AS [ValSchedulePolicy!3!RefProdProviderId],                  
 IsNull(T1.ClientCRMContactId,0) AS [ValSchedulePolicy!3!ClientCRMContactId],                  
 IsNull(T1.PolicyBusinessId,0) AS [ValSchedulePolicy!3!PolicyBusinessId],                  
 IsNull(T2.UserCredentialOption,'') AS [ValSchedulePolicy!3!UserCredentialOption],            
 IsNull(T1.PractitionerCRMContactId,0) AS [ValSchedulePolicy!3!PortalCRMContactId], --Selling Adviser CRMContactId            
 IsNull(T2.ScheduledLevel,'') AS [ValSchedulePolicy!3!ScheduledLevel]            
          
From          
PolicyManagement..TValSchedule T2 WITH(NOLOCK)         
Inner Join PolicyManagement..TValScheduleItem T3 WITH(NOLOCK) ON T2.ValScheduleId = T3.ValScheduleId          
Inner Join #PlansTable T1 WITH(NOLOCK) On T1.RefProdProviderId = T2.RefProdProviderId           
 And T1.ScheduledLevel = T2.ScheduledLevel And T2.PortalCRMContactId = T1.PractitionerCRMContactId          
          
Where           
T2.Islocked = 0      
And T1.PractitionerCRMContactId is Not Null            
And T2.ScheduledLevel = 'adviser'      
And T2.ValScheduleId = @ValScheduleId  
And T2.ClientCRMContactId is Null          
          
            
ORDER BY [ValSchedule!1!ProcessOrder], [ValSchedule!1!ValScheduleId], [ValScheduleItem!2!ValScheduleId], [ValSchedulePolicy!3!ValScheduleId], [ValScheduleItem!2!ValScheduleItemId]            
  
for xml explicit      