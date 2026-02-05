SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--increase the timedelay in the table as well.

CREATE PROCEDURE [dbo].[SpCustomRetrieveScheduledDetailsToProcess] @ServerName varchar(50), @MaxNoOfPlansToProcess int, @AcquiredTimeOutInterval int            
AS          

--16/01/2009 - mod to the list order & result returned so they are processed AtOrAfter submit time
--05/02/2009 - mod to return ScheduleDelay correctly - i.e. this represents the delay before the next request can be sent for the same provider
            
-- AcquiredTimeOutInterval - timeout in minutes, used to calculate AcquiredExpireTime            
            
/*            
--test            
declare @ServerName varchar(50), @MaxNoOfPlansToProcess int, @AcquiredTimeOutInterval int            
Set @ServerName = 'raj'            
Set @MaxNoOfPlansToProcess = 10            
Set @AcquiredTimeOutInterval = 10            
*/


exec dbo.SpNioCustomOpenSymmetricKeyForPasswordEncryption

Begin Tran RS            
            
--internal            
Declare @Max_AcquiredAtTime_For_Batch datetime            

--drop table #TValProcessItems            
            
Create table #TValProcessItems            
(            
 ValProcessItemsId bigint Identity(1,1),            
 ValScheduleScratchId bigint,            
 ValScheduleId bigint,            
 Guid varchar(50),            
 ScheduledLevel varchar(255),            
 ProcessOrder varchar(20),            
 IndigoClientId bigint,             
 RefProdProviderId bigint,            
 ClientCRMContactId bigint Null,            
 UserCredentialOption varchar(255),            
 PortalCRMContactId bigint Null,            
 UserId bigint,            
            
 Frequency varchar(255) Null,            
 IsLocked bit,            
 UserNameForFileAccess varchar(100) Null,            
 PasswordForFileAccess varchar(100) Null,            
 BulkValuationType varchar(100) Null,            
 ScheduleDelay int,            
            
 AlwaysAvailableFg bit Null,            
 DayOfTheWeek varchar(20) Null,            
 StartHour tinyint Null,            
 EndHour tinyint Null,            
 StartMinute tinyint Null,            
 EndMinute tinyint Null,            
            
 ValScheduleItemId bigint,                   
 ValQueueId bigint,                 
 NextOccurrence datetime,            
 LastOccurrence datetime,                   
 RefValScheduleItemStatusId bigint Null,      
 SaveAsFilePathAndName varchar(255) Null,   
                   
 PolicyBusinessId bigint,            
 SubmitAtOrAfter datetime,            
 IsProcessed bit Default(0),            
 DelayBeforNextSubmition bigint Default(0)            
)            
            
            
if @MaxNoOfPlansToProcess = 0             
 Set @MaxNoOfPlansToProcess = 10            

--test for 05/02/2009
Set @MaxNoOfPlansToProcess = 1
            
Insert Into #TValProcessItems            
(            
 ValScheduleScratchId, ValScheduleId, Guid, ScheduledLevel, ProcessOrder, IndigoClientId, RefProdProviderId, ClientCRMContactId,             
 UserCredentialOption, PortalCRMContactId, UserId, Frequency, IsLocked, UserNameForFileAccess, PasswordForFileAccess,             
 BulkValuationType, ScheduleDelay,             
 AlwaysAvailableFg, DayOfTheWeek, StartHour, EndHour, StartMinute, EndMinute,            
 ValScheduleItemId, ValQueueId, NextOccurrence, LastOccurrence, RefValScheduleItemStatusId, SaveAsFilePathAndName,  
 PolicyBusinessId, SubmitAtOrAfter, IsProcessed
)            
Select top(@MaxNoOfPlansToProcess)    
 A.ValScheduleScratchId, A.ValScheduleId, A.Guid, A.ScheduledLevel, A.ProcessOrder, A.IndigoClientId, A.RefProdProviderId, A.ClientCRMContactId,             
 A.UserCredentialOption, A.PortalCRMContactId, A.UserId, A.Frequency, A.IsLocked, A.UserNameForFileAccess, dbo.FnCustomDecryptPortalPassword(A.Password2ForFileAccess) , 
 A.BulkValuationType, A.ScheduleDelay,             
 A.AlwaysAvailableFg, A.DayOfTheWeek, A.StartHour, A.EndHour, A.StartMinute, A.EndMinute,          
 A.ValScheduleItemId, A.ValQueueId, A.NextOccurrence, A.LastOccurrence, A.RefValScheduleItemStatusId, A.SaveAsFilePathAndName,  
 A.PolicyBusinessId, SubmitAtOrAfter, IsProcessed 
            
From TValScheduleScratch A with(XLOCK)
Inner Join TValScheduleConfig B with(XLOCK) On A.RefProdProviderId = B.RefProdProviderId
Where             
Isnull(IsProcessed,0) = 0            
      
  
--Exclude Firm schedules for now - 07/07/2008 - process doesn;t work properly  
--Enabled firm schedules - 28/11/2008
--And A.ScheduledLevel != 'firm'  
      
            
--Current Time is greater then AcquiredExpireTime time            
And             
(            
 AcquiredBy Is Null Or (AcquiredBy Is not Null AND A.AcquiredExpireTime <= getdate())            
)            
            
And             
(            
/*            
--Current Time is greater then Schedule start time            
Dateadd(n, convert(int,SUBSTRING(B.ScheduleStartTime, 4, 2)),             
 dateadd(hh, convert(int,SUBSTRING(B.ScheduleStartTime, 1, 2)), convert(varchar(11), getdate(),121))) <= convert(varchar(24), getdate(),121)            
*/            

           
--Current Time is greater then SubmitAtOrAfter time            
--And
--original
----convert(varchar(24), getdate(),121) <= A.SubmitAtOrAfter
--new 2009-02-04
convert(varchar(24), getdate(),121) >= A.SubmitAtOrAfter

-----test line ----
-----convert(varchar(24), '2009-02-04 19:19:00.000',121) >= A.SubmitAtOrAfter
           
--Provider is Enabled for scheduling            
And             
Isnull(B.IsEnabled,0) = 1            
)            
            
            
--return records that are maked for processing - Null SubmitAtOrAfter means that we have gone over either our End OpTime or Providers EndTime            
And SubmitAtOrAfter is not Null            
            
--only return records which are with in the provider times            
And            
(          
 (            
 getdate() between            
  Dateadd(n, convert(int,StartMinute),             
   dateadd(hh, convert(int,StartHour), convert(varchar(11), getdate(),121)))            
             
  And            
             
  Dateadd(n, convert(int,EndMinute),             
   dateadd(hh, convert(int,EndHour), convert(varchar(11), getdate(),121)))            
             
 And             
             
 AlwaysAvailableFg = 0            
 )            
or          
 AlwaysAvailableFg = 1          
)          
            
order by a.processorder, a.submitatorafter, a.submitsequencebyprovider, a.valscheduleid
            
            
--Update TValScheduleScratch - AcquiredBy Server name and time            
Update A            
Set AcquiredBy = @ServerName, AcquiredAt = getdate()            
From TValScheduleScratch A            
Inner Join #TValProcessItems B on A.ValScheduleScratchId = B.ValScheduleScratchId            
            
            
--Get max/last SubmitAtOrAfter for batch - i.e. items just acquired            
Select @Max_AcquiredAtTime_For_Batch = Max(AcquiredAt)            
From TValScheduleScratch A            
Inner Join #TValProcessItems B on A.ValScheduleScratchId = B.ValScheduleScratchId            
            
            
--Update TValScheduleScratch - AcquiredExpireTime = AcquiredTimeOutInterval + @Max_AcquiredAtTime_For_Batch obtained from above logic    
--Update ONLY non firm records - by default add 30 mins   
Update A    
Set AcquiredExpireTime = DATEADD(n, @AcquiredTimeOutInterval, @Max_AcquiredAtTime_For_Batch)    
From TValScheduleScratch A    
Inner Join #TValProcessItems B on A.ValScheduleScratchId = B.ValScheduleScratchId    
Where A.ScheduledLevel <> 'firm'    
    
--Update TValScheduleScratch - AcquiredExpireTime = AcquiredTimeOutInterval + @Max_AcquiredAtTime_For_Batch obtained from above logic    
--Update ONLY firm records - by default add 30 min + 210 min = 4hrs total to process file schedules    
Update A    
Set AcquiredExpireTime = DATEADD(n, @AcquiredTimeOutInterval + 210, @Max_AcquiredAtTime_For_Batch)    
From TValScheduleScratch A    
Inner Join #TValProcessItems B on A.ValScheduleScratchId = B.ValScheduleScratchId    
Where A.ScheduledLevel = 'firm'    
       
            
--Update #TValProcessItems - DelayBeforNextSubmition - Used in dll to sleep until next submition time ---NOT NEEDED - remove this            
Update A            
Set DelayBeforNextSubmition = DATEDIFF(second, A.SubmitAtOrAfter, B.SubmitAtOrAfter)            
From #TValProcessItems A            
Inner Join #TValProcessItems B on B.ValProcessItemsId = (A.ValProcessItemsId + 1)            
            
            
--need to return SubmitAtOrAfter field in the list below            
--in dll - check next item's submitAtOrAfter time and sleep until next item's submitAtOrAfter time - if now < until next item's submitAtOrAfter time            



--Test for duplicate valuation - 2008-10-27
Insert Into TValScheduleDump (
	ValScheduleId, IndigoClientId, RefProdProviderId, ClientCRMContactId, PortalCRMContactId, UserId,
	ValScheduleScratchId, ValScheduleItemId, PolicyBusinessId, TimeStamp, AcquiredBy, 
	AcquiredAt, SubmitSequenceByProvider, SubmitAtOrAfter
) 
Select 
	T1.ValScheduleId, T1.IndigoClientId, T1.RefProdProviderId, T1.ClientCRMContactId, T1.PortalCRMContactId, T1.UserId,
	T1.ValScheduleScratchId, T1.ValScheduleItemId, T1.PolicyBusinessId, getdate(), @ServerName,
	T2.AcquiredAt, T2.SubmitSequenceByProvider, T2.SubmitAtOrAfter
From #TValProcessItems T1
Inner Join TValScheduleScratch T2 on T1.ValScheduleScratchId = T2.ValScheduleScratchId    

--End of Test code



            
--Main Select - a better way compared the four unions            
Select            
 IsNull(T1.ValScheduleId,0) AS [@ValScheduleId],                  
 IsNull(T1.Guid,'') AS [@Guid],                  
 IsNull(T1.ScheduledLevel,'') AS [@ScheduledLevel],                  
 Case                 
  When IsNull(T1.ScheduledLevel,'') = 'client' Then 1                
  When IsNull(T1.ScheduledLevel,'') = 'firm' Then 2                
  When IsNull(T1.ScheduledLevel,'') = 'adviser' Then 3                
 End                
 AS [@ProcessOrder],                
 IsNull(T1.IndigoClientId,0) AS [@IndigoClientId],                  
 IsNull(IC.FSA ,'') AS [@IndigoClientFSA],                 
 IsNull(G.FSARegNbr,'') AS [@GroupFSA],              
 IsNull(T1.RefProdProviderId,0) AS [@RefProdProviderId],                  
 IsNull(T1.ClientCRMContactId,0) AS [@ClientCRMContactId],                  
 IsNull(T1.UserCredentialOption,'') AS [@UserCredentialOption],                  
 IsNull(T1.PortalCRMContactId,0) AS [@PortalCRMContactId],                  
 IsNull(T1.UserId,0) AS [@UserId],                  
 --IsNull(CONVERT(varchar(24), T1.StartDate, 120),'') AS [ValSchedule!1!StartDate],                  
 IsNull(T1.Frequency,'') AS [@Frequency],                  
 IsNull(T1.IsLocked,0) AS [@IsLocked],                  
 IsNull(T1.UserNameForFileAccess,'') AS [@UserNameForFileAccess],                  
 IsNull(T1.PasswordForFileAccess,'') AS [@PasswordForFileAccess],                  
 IsNull(T1.BulkValuationType,'') AS [@BulkValuationType],            
 IsNull(T1.ScheduleDelay, 0) AS [@ScheduleDelay],                  
 IsNull(CONVERT(varchar(24), T1.SubmitAtOrAfter, 120),'') AS [@SubmitAtOrAfter],            
 IsNull(DelayBeforNextSubmition,0) AS [@DelayBeforNextSubmition],            
 IsNull(IsProcessed,0) AS [@IsProcessed],            
 IsNull(ValScheduleScratchId,0) AS [@ValScheduleScratchId],            
            
 --If no provider hours of operation defined, assume not available - i.e. can't request a valuation            
 IsNull(T1.AlwaysAvailableFg,0) AS [@AlwaysAvailableFg],                
 IsNull(T1.DayOfTheWeek,'') AS [@DayOfTheWeek],                
 IsNull(T1.StartHour,0) AS [@StartHour],                
 IsNull(T1.EndHour,0) AS [@EndHour],              
 IsNull(T1.StartMinute,0) AS [@StartMinute],              
 IsNull(T1.EndMinute,0) AS [@EndMinute],              
                
 IsNull(T1.ValScheduleItemId,0) AS [ValScheduleItem/@ValScheduleItemId],                  
 IsNull(T1.ValScheduleId,0) AS [ValScheduleItem/@ValScheduleId],                
 IsNull(T1.ValQueueId,0) AS [ValScheduleItem/@ValQueueId],            
 IsNull(CONVERT(varchar(24), T1.NextOccurrence, 120),'') AS [ValScheduleItem/@NextOccurrence],                   
 IsNull(CONVERT(varchar(24), T1.LastOccurrence, 120),'') AS [ValScheduleItem/@LastOccurrence],                     
 IsNull(T1.RefValScheduleItemStatusId,1) AS [ValScheduleItem/@RefValScheduleItemStatusId],
 IsNull(T1.SaveAsFilePathAndName,'') AS [ValScheduleItem/@SaveAsFilePathAndName],
 IsNull(VSI.DocVersionId, '') AS [ValScheduleItem/@DocVersionId],         
                 
 IsNull(T1.ValScheduleId,0) AS [ValScheduleItem/ValSchedulePolicy/@ValScheduleId],                   
 IsNull(T1.RefProdProviderId,0) AS [ValScheduleItem/ValSchedulePolicy/@RefProdProviderId],                      
 IsNull(T1.ClientCRMContactId,0) AS [ValScheduleItem/ValSchedulePolicy/@ClientCRMContactId],                      
 IsNull(T1.PolicyBusinessId,0) AS [ValScheduleItem/ValSchedulePolicy/@PolicyBusinessId],                      
 IsNull(T1.UserCredentialOption,'') AS [ValScheduleItem/ValSchedulePolicy/@UserCredentialOption],                
 IsNull(T1.PortalCRMContactId,0) AS [ValScheduleItem/ValSchedulePolicy/@PortalCRMContactId], --based on UserCredentialOption                
 IsNull(T1.ScheduledLevel,'') AS [ValScheduleItem/ValSchedulePolicy/@ScheduledLevel]            
            
                
FROM #TValProcessItems T1
JOIN TValSchedule s with (nolock) on t1.ValScheduleId = s.ValScheduleId
--Company FSA   
LEFT JOIN Administration..TIndigoclient IC WITH (NOLOCK) on T1.IndigoClientID = IC.IndigoClientID  
LEFT JOIN TValScheduleItem VSI WITH (NOLOCK) on T1.ValScheduleId = VSI.ValScheduleId 

--Group FSA
LEFT JOIN administration..TGroup G on g.GroupId = s.RefGroupId

Order By ValProcessItemsId

FOR XML PATH('ValSchedule')



Commit Tran RS
            
GO
