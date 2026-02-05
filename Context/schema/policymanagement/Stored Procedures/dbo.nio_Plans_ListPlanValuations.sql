SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[nio_Plans_ListPlanValuations]             
 @ClientCRMContactId int,             
 @LoggedOnUserId int            
AS          


/*  
--test            
declare @ClientCRMContactId bigint, @LoggedOnUserId varchar(50)              
set @ClientCRMContactId = 391300      
set @LoggedOnUserId = '8928'         
*/

DECLARE @MANUALUNDERLYINGFUND INT = 2, @REALTIME INT = 4,	
		@REALTIMEBATCH INT = 8, @BULKPROVIDER INT = 16, 
		@BULKMANUAL INT = 32, @BULKHIDDEN INT = 64, 
		@BULKMANUALTEMPLATE INT = 128
                
Declare @ServicingAdviserCRMContactId bigint, @LoggedOnUserCRMContactId bigint, @IndigoClientid bigint               
               
Select @ServicingAdviserCRMContactId = IsNull(CurrentAdviserCRMId,0)               
From CRM..TCRMContact  
Where CRMcontactId =  @ClientCRMContactId                
              
Select @LoggedOnUserCRMContactId = IsNull(CRMContactId,0) , @IndigoClientid = IndigoClientid              
From Administration..TUser 
Where UserId =  @LoggedOnUserId                
  
              

If Object_Id('tempdb..#Plans') Is Not Null              
 Drop Table #Plans              
              
Create Table #Plans(  
 PolicyDetailId bigint,  
 PolicyBusinessId bigint,  
 PlanDescriptionId bigint,  
 PlanValueDate datetime,  
 PlanValuationId bigint,  
 PolicyNumber varchar(255),
 PlanCurrencyCode varchar(50),  
 PractitionerId bigint,   
 SequentialRef varchar(50),  
 ShowSummary varchar(20) default 'False',  
 IsTopUp bit,  
 SupportedService int default(0)  
)              
  
  
--              
If Object_Id('tempdb..#PlansTemp') Is Not Null              
 Drop Table #PlansTemp              
              
Create Table #PlansTemp(              
 PolicyBusinessId bigint,               
 PlanValueDate datetime,               
 PlanValuationId bigint  
 )              
              
-- list in-force plans for client including topups  
Insert Into #Plans              
( PolicyDetailId, PolicyBusinessId, PolicyNumber, PlanCurrencyCode, PractitionerId, SequentialRef, PlanDescriptionId, IsTopUp)              
Select distinct A.PolicyDetailId, B.PolicyBusinessId, B.PolicyNumber, B.BaseCurrency, B.PractitionerId, B.SequentialRef, E.PlanDescriptionId,  
 Case When B.PolicyBusinessId = TPB.PolicyBusinessId Then 0 Else 1 End AS [IsTopUp]  
  
      
From TPolicyOwner A              
Inner Join TPolicyBusiness B On A.PolicyDetailId = B.PolicyDetailId              
Inner Join TStatusHistory C ON B.PolicyBusinessId = C.PolicyBusinessId AND C.CurrentStatusFG = 1                  
Inner Join TStatus D ON C.StatusId = D.StatusId AND D.IntelligentOfficeStatusType IN ('In force', 'Paid Up')
Inner Join TPolicyDetail E ON E.PolicyDetailId = A.PolicyDetailId  
  
  
-- check for Topup      
INNER JOIN (      
 SELECT A.PolicyDetailId, Min(PolicyBusinessId) AS PolicyBusinessId             
 From TPolicyBusiness A            
 JOIN TPolicyDetail B ON A.PolicyDetailId=B.PolicyDetailId            
 JOIN TPolicyOwner C ON B.PolicyDetailId=C.PolicyDetailId        
 WHERE C.CRMContactId=@ClientCRMContactId        
 Group By A.PolicyDetailId) AS TPB             
ON TPB.PolicyDetailId = B.PolicyDetailId       
      
Where B.IndigoClientId = @IndigoClientId And A.CRMContactId = @ClientCRMContactId              
  
  
  
----------- Get Plan valuation details -------------------------------            
              
-- Get Max( TPlanValuation.PlanValueDate )              
Insert into #PlansTemp              
( PolicyBusinessId, PlanValueDate )              
Select A.PolicyBusinessId, MAX(B.PlanValueDate)      
From #Plans A              
Inner join TPlanValuation B              
 On A.PolicyBusinessId = B.PolicyBusinessId              
Group By A.PolicyBusinessId              
        
Update A              
Set A.PlanValueDate = B.PlanValueDate              
From #Plans A              
Inner Join #PlansTemp B On A.PolicyBusinessId = B.PolicyBusinessId               
              
Truncate Table #PlansTemp              
              
-- Get Max ( TPlanValuation.PlanValuationId )               
Insert Into #PlansTemp              
( PolicyBusinessId, PlanValuationId)              
Select A.PolicyBusinessId, MAX(B.PlanValuationId)              
From #Plans A              
Inner join TPlanValuation B              
 On A.PolicyBusinessId = B.PolicyBusinessId And A.PlanValueDate = B.PlanValueDate              
Group By A.PolicyBusinessId      
              
Update A              
Set A.PlanValuationId = B.PlanValuationId              
From #Plans A              
Inner Join #PlansTemp B On A.PolicyBusinessId = B.PolicyBusinessId               
              
Drop Table #PlansTemp  
  
  
----------- Get valuation Status details -------------------------------      
If Object_Id('tempdb..#ValQueue') Is Not Null              
 Drop Table #ValQueue              

Create Table #ValQueue(PolicyBusinessId bigint, [Status] varchar(255), ValRequestId int, ValQueueId int)

	insert into #ValQueue(PolicyBusinessId, ValRequestId)
	SELECT 
	   C.PolicyBusinessId, 
	   MAX(C.ValRequestId) ValRequestId
	FROM	
	  (SELECT * FROM
		(SELECT 
		   PB.PolicyBusinessId,
		   MAX(vr.ValRequestId) ValRequestId	
		 FROM 	#Plans PB 
		 JOIN PolicyManagement..TValRequest VR ON PB.PolicyBusinessId = VR.PolicyBusinessId
		GROUP BY
			PB.PolicyBusinessId
		) A
	  UNION ALL
	  SELECT * FROM
	   (SELECT 
		   PB.PolicyBusinessId,	
		   MAX(sv.ValRequestId) ValRequestId
		FROM  #Plans PB 
		JOIN PolicyManagement..TValRequestSubPlan sv on sv.PolicyBusinessId = PB.PolicyBusinessId
		GROUP BY
		   PB.PolicyBusinessId
	   ) B
	 ) C
	GROUP BY
		C.PolicyBusinessId
		
Update A
Set 
 A.[Status] = C.[RequestStatus],
 A.ValRequestId = C.ValRequestId
From #ValQueue A
	Inner Join TValRequest C On a.ValRequestId = c.ValRequestId
		
--Mark Wrap policybusinessid             
Update A              
Set A.ShowSummary = 'True'            
From #Plans A              
Inner Join TWrapperPolicyBusiness B On A.PolicyBusinessId = B.ParentPolicyBusinessId               
      
  
/* CE Credentials Details */  
  
If Object_Id('tempdb..#ToSchedule') Is Not Null              
 Drop Table #ToSchedule   
  
Create table #ToSchedule (    
 ToScheduleId bigint identity(1,1),    
 PolicyBusinessId bigint,     
 PolicyDetailId bigint,    
 RefProdProviderId bigint,    
 ProviderName varchar(255),  
  
 SellingAdviserCRMContactId bigint,  
 SellingAdviserName varchar(255),  
 HasSellingAdviserPortalDetails bit Default(0),  
  
 ServicingAdviserCRMContactId bigint,  
 ServicingAdviserName varchar(255),  
 HasServicingAdviserPortalDetails bit Default(0),  
  
 LoggedOnUserCRMContactId bigint,  
 LoggedOnUserName varchar(255),  
 HasLoggedOnUserPortalDetails bit Default(0)  
 )    
  
  
  
  
Insert Into #ToSchedule (PolicyBusinessId, PolicyDetailId, RefProdProviderId, ProviderName,  
 SellingAdviserCRMContactId, ServicingAdviserCRMContactId, LoggedOnUserCRMContactId )    
Select distinct T4.PolicyBusinessId, T2.PolicyDetailId, T3.RefProdProviderId, T6.CorporateName,  
 tpract.CRMContactId, @ServicingAdviserCRMContactId, @LoggedOnUserCRMContactId  
  
From PolicyManagement..TPolicyDetail T1           
    
Inner Join PolicyManagement..TPolicyOwner T2 ON T1.PolicyDetailId = T2.PolicyDetailId AND T2.CRMContactId = @ClientCRMContactId          
Inner Join PolicyManagement..TPlanDescription T3 On T3.PlanDescriptionId = T1.PlanDescriptionId      
Inner Join PolicyManagement..TPolicyBusiness T4 On T1.PolicyDetailId = T4.PolicyDetailId  
  
    
--RefProdProvider Name  - use for testing only      
Inner Join PolicyManagement..TRefProdProvider T5 On T5.RefProdProviderId = T3.RefProdProviderId    
Inner Join CRM..TCRMContact T6 On T6.CRMContactId = T5.CRMContactId        
  
--SellingAdviser  
Inner Join CRM..TPractitioner tpract On tpract.PractitionerId = T4.PractitionerId  
  
Where T4.PolicyBusinessId in (Select PolicyBusinessId from #Plans)   
  
  
--Update all the Linked RefProdProviderIds to the MappedRefProdProviderIds - i.e the ones that handle the requests    
Update #ToSchedule    
Set #ToSchedule.RefProdProviderId = TLUp.MappedRefProdProviderId    
From PolicyManagement..TValLookUp TLUp     
Where #ToSchedule.RefProdProviderId = TLUp.RefProdProviderId    
  
  
--Update SellingAdviser Details  
Update Main  
Set   
 SellingAdviserName = IsNull(B.FirstName + ' ' + B.LastName,''),  
 HasSellingAdviserPortalDetails =   
  Case 
	When IsNull(C.AuthenticationType,0) = 0 Then
		Case When IsNull(E.ValPortalSetupId,0) = 0 Then 0 Else 1 End       
	When IsNull(C.AuthenticationType,0) = 1 Then
		Case When IsNull(D.CertificateId,0) = 0 Then 0 Else 1 End
	When IsNull(C.AuthenticationType,0) = 2 Then
		Case When ( (IsNull(E.ValPortalSetupId,0) = 0) and (IsNull(D.CertificateId,0) = 0) ) Then 0 else 1 end
   end
	
From   
 #ToSchedule Main  
 Inner Join #ToSchedule TSch On Main.PolicyBusinessId = TSch.PolicyBusinessId  
     
 Inner Join CRM..TCRMContact B On Main.SellingAdviserCRMContactId = B.CRMContactId --SellingAdviserName      
  
 --ProviderConfig  
 Left Join Policymanagement.dbo.TValProviderConfig C On C.RefProdProviderId = TSch.RefProdProviderId      
  
 --UniPass      
 Left Join Administration..TCertificate D On D.CRMContactId = IsNull(B.CRMContactId,0)       
  And D.IsRevoked = 0 And D.HasExpired = 0 -- Unipass for SellingAdviserCRMContactId      
  
 --Non UniPass      
 Left Join PolicyManagement..TValPortalSetup E On E.RefProdProviderId = TSch.RefProdProviderId   
  And E.CRMContactId = IsNull(B.CRMContactId,0)  -- PortalSetup for SellingAdviserCRMContactId   
  
  
--Update ServicingAdviser Details  
Update Main  
Set   
 ServicingAdviserName = IsNull(B.FirstName + ' ' + B.LastName,''),  
 HasServicingAdviserPortalDetails =   
  Case 
	When IsNull(C.AuthenticationType,0) = 0 Then
		Case When IsNull(E.ValPortalSetupId,0) = 0 Then 0 Else 1 End       
	When IsNull(C.AuthenticationType,0) = 1 Then
		Case When IsNull(D.CertificateId,0) = 0 Then 0 Else 1 End
	When IsNull(C.AuthenticationType,0) = 2 Then
		Case When ( (IsNull(E.ValPortalSetupId,0) = 0) and (IsNull(D.CertificateId,0) = 0) ) Then 0 else 1 end
   end  
  
From   
 #ToSchedule Main  
 Inner Join #ToSchedule TSch On Main.PolicyBusinessId = TSch.PolicyBusinessId  
  
 Inner Join CRM..TCRMContact B On Main.ServicingAdviserCRMContactId = B.CRMContactId --ServicingAdviserName   
   
 --ProviderConfig  
 Left Join Policymanagement.dbo.TValProviderConfig C On C.RefProdProviderId = TSch.RefProdProviderId      
  
 --UniPass      
 Left Join Administration..TCertificate D On D.CRMContactId = IsNull(B.CRMContactId,0)       
  And D.IsRevoked = 0 And D.HasExpired = 0 -- Unipass for ServicingAdviserCRMContactId      
  
 --Non UniPass      
 Left Join PolicyManagement..TValPortalSetup E On E.RefProdProviderId = TSch.RefProdProviderId   
  And E.CRMContactId = IsNull(B.CRMContactId,0)  -- PortalSetup for ServicingAdviserCRMContactId        
  
  
--Update LoggedOnUser Details  
Update Main  
Set   
 LoggedOnUserName = IsNull(B.FirstName + ' ' + B.LastName,''),  
 HasLoggedOnUserPortalDetails =   
  Case 
	When IsNull(C.AuthenticationType,0) = 0 Then
		Case When IsNull(E.ValPortalSetupId,0) = 0 Then 0 Else 1 End       
	When IsNull(C.AuthenticationType,0) = 1 Then
		Case When IsNull(D.CertificateId,0) = 0 Then 0 Else 1 End
	When IsNull(C.AuthenticationType,0) = 2 Then
		Case When ( (IsNull(E.ValPortalSetupId,0) = 0) and (IsNull(D.CertificateId,0) = 0) ) Then 0 else 1 end
   end 
  
From  
 #ToSchedule Main  
 Inner Join #ToSchedule TSch On Main.PolicyBusinessId = TSch.PolicyBusinessId  
   
 Inner Join CRM..TCRMContact B On Main.LoggedOnUserCRMContactId = B.CRMContactId --LoggedOnUserName   
  
 --ProviderConfig  
 Left Join Policymanagement.dbo.TValProviderConfig C On C.RefProdProviderId = TSch.RefProdProviderId      
  
 --UniPass      
 Left Join Administration..TCertificate D On D.CRMContactId = IsNull(B.CRMContactId,0)       
  And D.IsRevoked = 0 And D.HasExpired = 0 -- Unipass for LoggedOnUserCRMContactId      
  
 --Non UniPass      
 Left Join PolicyManagement..TValPortalSetup E On E.RefProdProviderId = TSch.RefProdProviderId   
  And E.CRMContactId = IsNull(B.CRMContactId,0)  -- PortalSetup for LoggedOnUserCRMContactId      
  
  
  
--Update SupportedService values of the main providers   
Update a  
Set a.SupportedService = vpc.SupportedService  
From #Plans a  
Inner Join Policymanagement..TPolicyBusiness pb On a.PolicyBusinessId = pb.PolicyBusinessId  
Inner join Policymanagement..TPolicyDetail pd On pb.PolicyDetailId = pd.PolicyDetailId  
Inner join Policymanagement..TPlanDescription pdd On pd.PlanDescriptionid = pdd.PlanDescriptionid  
Inner join Policymanagement..TValProviderConfig vpc On vpc.RefProdProviderId = pdd.RefProdProviderId  
  
  
--Update SupportedService values of the linked providers   
Update a  
Set a.SupportedService = vpc.SupportedService  
From #Plans a  
Inner Join Policymanagement..TPolicyBusiness pb On a.PolicyBusinessId = pb.PolicyBusinessId  
Inner join Policymanagement..TPolicyDetail pd On pb.PolicyDetailId = pd.PolicyDetailId  
Inner join Policymanagement..TPlanDescription pdd On pd.PlanDescriptionid = pdd.PlanDescriptionid  
Inner Join Policymanagement..TValLookUp lup On lup.RefProdProviderId = pdd.RefProdProviderId  
Inner join Policymanagement..TValProviderConfig vpc On vpc.RefProdProviderId = lup.MappedRefProdProviderId  


----------- Main Select -------------------------------
SELECT
    T1.PolicyBusinessId AS PolicyBusinessId,
    T1.SequentialRef As SequentialRef,
    T1.PolicyDetailId AS PolicyDetailId,
    T1.PolicyNumber AS PolicyNumber,
    T1.IsTopUp AS IsTopUp,
    T1.PlanCurrencyCode as PlanCurrencyCode,
    T9.RefProdProviderId AS RefProdProviderId,
    T10.CorporateName AS ProviderName,
    T8.PlanTypeName AS PlanTypeName,
    tpv.PlanValuationId AS PlanValuationId,
    ISNULL(tpv.PlanValue, 0) AS PlanValue,
    tpv.PlanValueDate AS PlanValueDate,
    tpv.WhoUpdatedValue AS WhoUpdatedValue,
    ISNULL(tpv.RefPlanValueTypeId, '') AS RefPlanValueTypeId,
    ISNULL(tpv2.RefPlanValueType, '') AS RefPlanValueType,
    ISNULL(T14.AuthenticationType, 0) AS AuthenticationType,
    Case
        When (
                ((T1.SupportedService & @BULKPROVIDER = @BULKPROVIDER) or (T1.SupportedService & @BULKHIDDEN = @BULKHIDDEN))
                    and
                ((T1.SupportedService & @REALTIME = @REALTIME) or (T1.SupportedService & @REALTIMEBATCH = @REALTIMEBATCH))
            ) then 'RT/Bulk'
        When
            (T1.SupportedService & @REALTIME = @REALTIME) or (T1.SupportedService & @REALTIMEBATCH = @REALTIMEBATCH) then 'RT'
        When
            (T1.SupportedService & @BULKPROVIDER = @BULKPROVIDER) or (T1.SupportedService & @BULKHIDDEN = @BULKHIDDEN)  then 'Bulk'
        Else 'None'
    End IsGatedForValuation,

 IsNull(tvq.ValQueueId,0) AS ValQueueId,  

 /*if it is not RT then there shouldn't be any Last RT Status - QA CR Fix*/
 Case When   
  (T1.SupportedService & @REALTIME = @REALTIME) OR  (T1.SupportedService & @REALTIMEBATCH   = @REALTIMEBATCH)  
 Then tvq.Status
 Else ''  
End AS LastValuationStatus,

 IsNull(tvq.ValRequestId,0) AS ValRequestId,  
 IsNull(tvres.ValResponseId,0) AS ValResponseId,  
 T1.ShowSummary AS ShowSummary,  
  
/* CE Credentials Details */  
  
 creds.SellingAdviserCRMContactId,  
 creds.SellingAdviserName,  
 creds.HasSellingAdviserPortalDetails,  
  
 creds.ServicingAdviserCRMContactId,  
 creds.ServicingAdviserName,  
 creds.HasServicingAdviserPortalDetails,  
  
 creds.LoggedOnUserCRMContactId,  
 creds.LoggedOnUserName,  
 creds.HasLoggedOnUserPortalDetails,  
 T1.SupportedService,
  
 T7.RefPlanType2ProdSubTypeId AS PlanProductTypeId,

 tvres.ProviderErrorCode As ProviderErrorCode,
 tvres.ProviderErrorDescription AS ProviderErrorDescription,
 ISNULL(tvres.ErrorDescription, '') As MessagingErrorDescription,
 TPB.AgencyStatus AS AgencyStatus
                  
FROM #Plans T1              
      
--INNER JOIN [CRM]..TPractitioner  T12 ON T12.PractitionerId = T1.PractitionerId  
    
INNER JOIN TPlanDescription T6 ON T1.PlanDescriptionId = T6.PlanDescriptionId                   
INNER JOIN TRefPlanType2ProdSubType T7 ON T6.RefPlanType2ProdSubTypeId = T7.RefPlanType2ProdSubTypeId                   
INNER JOIN TRefPlanType T8 ON T7.RefPlanTypeId = T8.RefPlanTypeId                   
INNER JOIN TRefProdProvider T9 ON T6.RefProdProviderId = T9.RefProdProviderId                   
INNER JOIN [CRM].[dbo].TCRMContact T10 ON T9.CRMContactId = T10.CRMContactId                  
                  
LEFT JOIN PolicyManagement.dbo.TPlanValuation tpv               
 On T1.PlanValuationId = tpv.PlanValuationId              
Left Join PolicyManagement.dbo.TRefPlanValueType tpv2 ON tpv.RefPlanValueTypeId = tpv2.RefPlanValueTypeId              
              
LEFT JOIN PolicyManagement.dbo.TValProviderConfig T14 On T14.RefProdProviderId = T6.RefProdProviderId                  
LEFT JOIN TProdSubType T16 on T16.ProdSubTypeId = T7.ProdSubTypeId                  
LEFT JOIN PolicyManagement.dbo.TValGating T15              
 On          
(          
 T15.RefProdproviderId In           
 ( --Case 22225 - check for linked providers          
  Select a.MappedRefProdProviderId--, lookupId = b.RefProdProviderId           
  From PolicyManagement..TValLookup A             
  Where A.RefProdProviderId = T6.RefProdproviderId          
 )          
  OR           
 T15.RefProdproviderId = T6.RefProdproviderId           
)          
          

-- T15.RefProdproviderId = T6.RefProdproviderId           
 And T15.RefPlanTypeId = T8.RefPlanTypeId                  
    And (IsNull(T15.ProdSubTypeId,0) = IsNull(T16.ProdSubTypeId,0))           
          
             
Left Join #ValQueue tvq On tvq.PolicyBusinessId = T1.PolicyBusinessId              

--IO-30928 - we don't need this as the data is coming from #ValQueue
--Left Join PolicyManagement.dbo.TValRequest tvreq     
-- -- 12 may 2009    
-- -- changed the join to remove the IsNull call below    
-- -- On tpv.PlanValuationId = IsNull(tvreq.PlanValuationId,0)           
-- On tpv.PlanValuationId = tvreq.PlanValuationId And  tvreq.PlanValuationId is not null    
    
Left Join PolicyManagement.dbo.TValResponse tvres On IsNull(tvres.ValRequestId,0) = tvq.ValRequestId
  
--CE Credentials   
Inner Join #ToSchedule creds On creds.PolicyBusinessId = T1.PolicyBusinessId  
LEFT JOIN TPolicyBusinessExt TPB ON TPB.PolicyBusinessId = T1.PolicyBusinessId
                
Order By IsNull(T10.CorporateName,''), IsNull(T8.PlanTypeName,''), IsNull(T1.PolicyNumber,'')

GO
