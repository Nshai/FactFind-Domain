SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
	Custom Sp to Retrieve User Schedules - i.e. for all the given providers, scheduled level and user, return the schedules
	LIO Procedure: SpCustomRetrieveSchedules
*/ 

CREATE PROCEDURE [dbo].[nio_ContractEnquiry_RetrieveUserSchedules]  
@RefProdProviderIds varchar(1000),  
@UserCRMContactId varchar(50),  
@ScheduledLevel varchar (255)  
AS  

/*
select @RefProdProviderIds='236,', @LoggedOnUserId=134, @ScheduledLevel='adviser'
*/

declare @Array varchar(1000)  
declare @BigintTable table (BigintValue bigint)  
declare @separator char(1)  
  
set @separator = ','  
set @Array = @RefProdProviderIds  
  
declare @separator_position int   
declare @array_value varchar(1000)   
   
set @array = @array + ','  
   
while patindex('%,%' , @array) <> 0   
begin  
   
  select @separator_position =  patindex('%,%' , @array)  
  select @array_value = left(@array, @separator_position - 1)  
  
  Insert @BigintTable  
  Values (Cast(@array_value as int))  
  
  select @array = stuff(@array, 1, @separator_position, '')  
end  
  

BEGIN  
  SELECT  
    T1.ValScheduleId AS [ValScheduleId],     
    T1.Guid AS [Guid],     
    T1.ScheduledLevel AS [ScheduledLevel],     
    T1.RefProdProviderId AS [RefProdProviderId],     
    T2.PolicyBusinessId AS [PolicyBusinessId],     
    T1.ClientCRMContactId AS [ClientCRMContactId],     
    T1.UserCredentialOption AS [UserCredentialOption],     
    T1.PortalCRMContactId AS [PortalCRMContactId],     
    CONVERT(varchar(24), T1.StartDate, 120) AS [StartDate],     
    T1.Frequency AS [Frequency],  
    T1.IsLocked AS [IsLocked]   ,
    T1.ConcurrencyId AS [ConcurrencyId]    
  FROM Policymanagement..TValSchedule T1  
  Left Join Policymanagement..TValSchedulePolicy T2 On T1.ValScheduleId = T2.ValScheduleId  
    
  WHERE T1.RefProdProviderId IN (Select BigintValue From @BigintTable) 
--		AND (@ScheduledLevel != 'client' or (@ScheduledLevel = 'client' And T1.PortalCRMContactId = @LoggedOnUserCRMContactId)) AND       
		And T1.PortalCRMContactId = @UserCRMContactId
        And T1.ScheduledLevel = @ScheduledLevel      
  
  ORDER BY [ValScheduleId]  
  
  
END
GO
