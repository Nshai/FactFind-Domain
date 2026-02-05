USE [policymanagement]
GO

/****** Object:  StoredProcedure [dbo].[nio_ContractEnquiry_UserSchedule]    Script Date: 07/11/2013 10:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


Create PROCEDURE [dbo].[nio_ContractEnquiry_UserSchedule] 
@UserCRMContactId bigint, @TenantId bigint
AS  

/*  
 Custom SP for retrieving User Contract Enquiry Settings for the Portals page.  
 LIO Procedure: SpCustomRetrieveUserContractEnquirySettings  
*/    

exec dbo.SpNioCustomOpenSymmetricKeyForPasswordEncryption
               
----Main Select      
              
Select Distinct                
  
IsNull(T4.ValPortalSetupId,'') AS [ValPortalSetupId],  
IsNull(T4.CRMContactId,'') AS [CRMContactId],                        
IsNull(T1.RefProdProviderId,'') AS [RefProdProviderId],  
IsNull(T3.CorporateName,'') AS [ProviderName],         
  
IsNull(T4.UserName,'') AS [UserName],              
dbo.FnCustomDecryptPortalPassword(T4.Password2) AS [Password],

ISNULL(T4.Passcode, '') as [Passcode],
T4.CreatedDate AS [CreatedDate],  
IsNull(T4.ConcurrencyId,'') AS [ConcurrencyId],  
            
T1.AuthenticationType AS AuthenticationType,  

0 AS [IsLocked],
                
 IsNuLL(CONVERT(varchar(24), TSch.StartDate, 103),'') AS [ScheduleValuationStartDate],                
 IsNull(TSch.Frequency,'') AS [ScheduleValuationFrequency],          
  
 T1.SupportedService AS [SupportedService]
 
              
From PolicyManagement.dbo.TValProviderConfig T1 WITH(NOLOCK)       
              
Inner Join PolicyManagement.dbo.TRefProdProvider T2 WITH(NOLOCK)         
On T1.RefProdProviderId = T2.RefProdProviderId                  
              
Inner Join CRM.dbo.TCRMContact T3 WITH(NOLOCK)       
On T2.CRMContactId = T3.CRMContactId              
              
Inner Join PolicyManagement.dbo.TValPortalSetup T4 WITH(NOLOCK)       
On T1.RefProdProviderId = T4.RefProdProviderId And T4.CRMContactId = @UserCRMContactId              
              
Left Join PolicyManagement.dbo.TValSchedule TSch WITH(NOLOCK)       
 On TSch.RefProdProviderId = T1.RefProdProviderId                 
 And TSch.ScheduledLevel = 'adviser'                
 And TSch.PortalCRMContactId = T4.CRMContactId -- Added this on 31/08/2006                
          
 
Where IsNull(T1.AuthenticationType,0) = 0              
  
  
union               
              
Select Distinct                
  
(1000000 + T1.RefProdProviderId) AS [ValPortalSetupId],     
@UserCRMContactId AS [CRMContactId],      
IsNull(T1.RefProdProviderId,'') AS [RefProdProviderId],   
IsNull(T3.CorporateName,'') AS [ProviderName],         
  
Null AS [UserName],              
Null AS [Password],      
Null as [Passcode],        
Null AS [CreatedDate],     
Null AS [ConcurrencyId],     
  
T1.AuthenticationType AS AuthenticationType,    

0 AS [IsLocked],
 
 IsNuLL(CONVERT(varchar(24), TSch.StartDate, 103),'') AS [ScheduleValuationStartDate],  
 IsNull(TSch.Frequency,'') AS [ScheduleValuationFrequency],  
 
 T1.SupportedService AS [SupportedService]  

              
From PolicyManagement.dbo.TValProviderConfig T1 WITH(NOLOCK)       
              
Inner Join PolicyManagement.dbo.TRefProdProvider T2 WITH(NOLOCK)         
On T1.RefProdProviderId = T2.RefProdProviderId      
              
Inner Join CRM.dbo.TCRMContact T3 WITH(NOLOCK)       
On T2.CRMContactId = T3.CRMContactId              
              
--Adviser schedule              
Left Join PolicyManagement.dbo.TValSchedule TSch WITH(NOLOCK)       
 On TSch.RefProdProviderId = T1.RefProdProviderId                 
 And TSch.ScheduledLevel = 'adviser'                
 And TSch.PortalCRMContactId = @UserCRMContactId -- Added this on 31/08/2006                
             
Where IsNull(T1.AuthenticationType,0) = 1                
  
              
--ORDER BY [ProviderName]                  
                  
  


GO


