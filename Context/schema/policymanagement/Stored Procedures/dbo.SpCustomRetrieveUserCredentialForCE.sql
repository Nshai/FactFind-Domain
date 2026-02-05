SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveUserCredentialForCE]
 @PolicyBusinessId bigint, @ClientCRMContactId bigint, @LoggedOnUserId varchar(50)    
AS    
    
BEGIN  
  
--declare @PolicyBusinessId bigint, @ClientCRMContactId bigint, @LoggedOnUserId varchar(50)    
--Select @PolicyBusinessId = 2947, @ClientCRMContactId = 3324, @LoggedOnUserId = 134  
  
    
Declare @AuthenticationType tinyint, @RefProdProviderId bigint      
      
Select @RefProdProviderId = C.RefProdProviderId      
From PolicyManagement..TPolicyBusiness A      
Inner Join PolicyManagement..TPolicyDetail B On A.PolicyDetailId = B.PolicyDetailId      
Inner Join PolicyManagement..TPlanDescription C On C.PlanDescriptionId = B.PlanDescriptionId      
Where A.PolicyBusinessId = @PolicyBusinessId  
  
If exists(select 1 from PolicyManagement..TValLookUp where RefProdProviderId = @RefProdProviderId)  
begin  
 Select @RefProdProviderId = MappedRefProdProviderId   
 from PolicyManagement..TValLookUp   
 where RefProdProviderId = @RefProdProviderId  
end   
  
      
Select @AuthenticationType = AuthenticationType, @RefProdProviderId = A.RefProdProviderId      
From PolicyManagement..TValProviderConfig A  
Where A.RefProdProviderId = @RefProdProviderId    
      
      
Select distinct 1 As tag,      
 Null AS parent,      
 IsNull(@AuthenticationType,0) AS [UserCredential!1!AuthenticationType],      
 IsNull(@ClientCRMContactId,0) AS [UserCredential!1!ClientCRMContactId],      
 IsNull(D.FirstName + ' ' + D.LastName,'') AS [UserCredential!1!ClientName],      
 IsNull(B.CRMContactId,0) AS [UserCredential!1!SellingAdviserCRMContactId],      
 IsNull(C.FirstName + ' ' + C.LastName,'') AS [UserCredential!1!SellingAdviserName],       
    
 Case When IsNull(@AuthenticationType,0) = 1     
 then    
 Case When IsNull(K.CertificateId,0) = 0 Then 0 Else 1 End     
 else    
 Case When IsNull(G.ValPortalSetupId,0) = 0 Then 0 Else 1 End     
 end AS [UserCredential!1!HaveSellingAdviserPortalDetails],      
    
 IsNull(D.CurrentAdviserCRMId,0) AS [UserCredential!1!ServicingAdviserCRMContactId],      
 IsNull(D.CurrentAdviserName,'') AS [UserCredential!1!ServicingAdviserName],      
    
 Case When IsNull(@AuthenticationType,0) = 1     
 then    
 Case When IsNull(L.CertificateId,0) = 0 Then 0 Else 1 End     
 else    
 Case When IsNull(H.ValPortalSetupId,0) = 0 Then 0 Else 1 End     
 end AS [UserCredential!1!HaveServicingAdviserPortalDetails],      
    
 IsNull(E.CRMContactId,0) AS [UserCredential!1!LoggedOnUserCRMContactId],      
 IsNull(F.FirstName + ' ' + F.LastName,'') AS [UserCredential!1!LoggedOnUserName],      
    
 Case When IsNull(@AuthenticationType,0) = 1     
 then    
 Case When IsNull(M.CertificateId,0) = 0 Then 0 Else 1 End     
 else    
 Case When IsNull(J.ValPortalSetupId,0) = 0 Then 0 Else 1 End     
 end AS [UserCredential!1!HaveLoggedOnUserPortalDetails],

 IsNull(@RefProdProviderId,0) AS [UserCredential!1!ValuationProvider]

From PolicyManagement..TPolicyBusiness A      
Inner Join CRM..TPractitioner B On A.PractitionerId = B.PractitionerId      
Inner Join CRM..TCRMContact C On C.CRMContactId = B.CRMContactId --SellingAdviserName      
Inner Join CRM..TCRMContact D On D.CRMContactId = @ClientCRMContactId --ClientName      
Inner Join Administration..TUser E On E.UserId =  @LoggedOnUserId      
Inner Join CRM..TCRMContact F On F.CRMContactId = E.CRMContactId --LoggedOnUserName      
--Non-Unipass    
Left Join PolicyManagement..TValPortalSetup G On G.RefProdProviderId = @RefProdProviderId and G.CRMContactId = IsNull(B.CRMContactId,0)  -- PortalSetup for SellingAdviserCRMContactId      
Left Join PolicyManagement..TValPortalSetup H On H.RefProdProviderId = @RefProdProviderId and H.CRMContactId = IsNull(D.CurrentAdviserCRMId,0)  -- PortalSetup for ServicingAdviserCRMContactId      
Left Join PolicyManagement..TValPortalSetup J On J.RefProdProviderId = @RefProdProviderId and J.CRMContactId = IsNull(E.CRMContactId,0)  -- PortalSetup for LoggedOnUserCRMContactId      
    
--UniPass    
Left Join Administration..TCertificate K On K.CRMContactId = IsNull(B.CRMContactId,0)     
 And K.IsRevoked = 0 And K.HasExpired = 0 -- Unipass for SellingAdviserCRMContactId    
Left Join Administration..TCertificate L On L.CRMContactId = IsNull(D.CurrentAdviserCRMId,0)    
 And L.IsRevoked = 0 And L.HasExpired = 0 -- Unipass for ServicingAdviserCRMContactId    
Left Join Administration..TCertificate M On M.CRMContactId = IsNull(E.CRMContactId,0)    
 And M.IsRevoked = 0 And M.HasExpired = 0 -- Unipass for LoggedOnUserCRMContactId    
    
    
Where A.PolicyBusinessId = @PolicyBusinessId      
      
for xml explicit          
  
END    
  
GO
