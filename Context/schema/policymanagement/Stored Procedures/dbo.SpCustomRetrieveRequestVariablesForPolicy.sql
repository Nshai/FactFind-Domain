SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SpCustomRetrieveRequestVariablesForPolicy] @PolicyBusinessId bigint, @PortalCRMContactId bigint                  
AS

  
/*    
02/12/2009 - Add code to extract @CertificatePostCode to be used for Zurich      
    
14/12/2009 - Added new attribute (ChangeX509DataOrder) to control the X590 subject name ordering -     
   -- for LV we need to order by Big Endian everyone else Little Big ndian    
Values:     
 Default - 0 = Little Endian e.g  E=akeel.ahmed@intelliflo.com, CN=Intelliflo Plc, OU=BPSW19 4DS etc...    
 1 = Big Endian e.g. C=GB, O=FirmID2100010047396441648SL71HZ, OU=CPS - www.unipass.co.uk/cps etc..     
    
RC - 11/02/2010 - After speaking with Zurich - we need to pick up the branch post code NOT the one with the FIRMID node    
KK - 24/Mar/2011 - Zuric Requires to have the associated Froup FSA as opposed to the parent group    #
RC - 28/Mar/2012 - L&G as a client - modified code to check tenant preference to see if we need to return the Username (by default)
	 or the User Guid as @PortalCRMContactId's for LG
*/    
    
/*                  
declare @PolicyBusinessId bigint, @PortalCRMContactId bigint                      
set @PolicyBusinessId = 3948896                  
set @PortalCRMContactId = 857122 --693597                  
*/        
                  
Declare @RefProdProviderId bigint, @FSAReference varchar(255), @AdviserPostCode varchar(20)            
Declare @AdviserName varchar(255) 
Declare @GroupFSA varchar(50) 
Declare @UserGuid varchar(255), @ReturnUserGuid bit
        
Declare @ParentPolicyBusinessId bigint, @UseMasterPlan bit, @RefPlanType2ProdSubTypeId bigint            
      
exec dbo.SpNioCustomOpenSymmetricKeyForPasswordEncryption

--Certificate details      
Declare @Subject varchar(255), @StartOfFirmID int, @CommaAfterFirmID int, @CertificatePostCode varchar(20)      
Declare @StartOfBP int, @CommaAfterBP varchar(20)      
Declare @OrderAsLittleEndian bit    
      
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

--CertificatePostCode is only required for Zurich and Zurich Intermediary Platform for now
Declare @ZurichRefProdProviderId bigint, @ZIPRefProdProviderId bigint
Declare @CertificatePostCodeRequiredProviderIds as table (RefProdproviderid bigint)

insert into @CertificatePostCodeRequiredProviderIds
select refprodproviderid from vprovider where name in ('Zurich' , 'Zurich Intermediary Platform')

if exists (select 1 from @CertificatePostCodeRequiredProviderIds where RefProdproviderid = @RefProdProviderId) 
begin

		if exists(Select 1 From Administration..TCertificate where CRMContactId = @PortalCRMContactId)      
		Begin      
      
			Select @Subject = IsNull(Subject,'') From Administration..TCertificate where CRMContactId = @PortalCRMContactId      
      
			Set @Subject = replace(@Subject, ' ', '~')    
    
			Set @StartOfBP=patindex('%OU=BP%', @Subject)    
			Set @CommaAfterBP=patindex('%CN=%', @Subject)    
    
			Set @CertificatePostCode = substring(@Subject, @StartOfBP + 5, (@CommaAfterBP - (@StartOfBP + 7) ) )    
			Set @CertificatePostCode = replace(@CertificatePostCode, '~', ' ')    
    
		End      
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
        
  --just to be safe        
  set @PolicyBusinessId = @ParentPolicyBusinessId        
 End        
end         
                      
--Check for main provider for the selected policy        
If exists(select 1 from PolicyManagement..TValLookUp where RefProdProviderId = @RefProdProviderId)                  
begin                  
 Select @RefProdProviderId = MappedRefProdProviderId                   
 from PolicyManagement..TValLookUp                   
 where RefProdProviderId = @RefProdProviderId                  
end                   
    
    
--ChangeX509DataOrder    
set @OrderAsLittleEndian = 1 --default - as we started with this    
    
--For LV change the order    
if @RefProdProviderId = 204    
 set @OrderAsLittleEndian = 0    
    
              
-- Get the advisers/users FSA reference and name            
Select @FSAReference = FSAReference from CRM..TPractitioner where CRMContactId = @PortalCRMContactId        
      
Select @AdviserName  = IsNUll(C.FirstName,'') + ' ' + IsNull(C.LastName,''), @GroupFSA = FSARegNbr, @UserGuid = IsNull(U.Guid,'')
 from CRM..TCRMContact C    
 Join Administration..TUser U on C.CrmcontactId = U.CrmcontactId    
 Left Join Administration..TGroup G on U.GroupId = g.groupId     
where C.CRMContactId = @PortalCRMContactId    
    
-- Get the advisers business postcode              
Select @AdviserPostCode = ISNull(B.Postcode,'')              
From CRM..TAddress A              
Inner Join CRM..TAddressStore B On A.AddressStoreId = B.AddressStoreId              
Where A.CRMContactid = @PortalCRMContactId And A.RefAddresstypeId = 2 And A.DefaultFg = 1              
      
-- Check the UseUserGuidForCE value in TIndigoClientPreference to see if we need to return thr UserGuid or the UserName
Set @ReturnUserGuid = 0 -- default - i.e. return what the user has entered in the TValPortalSetup

If Exists (Select 1 from Administration..TIndigoClientPreference where PreferenceName = 'UseUserGuidForCE' And Value = 'true' and Disabled = 0) 
	Select @ReturnUserGuid = 1

                      
Select                        
 1 as tag,                        
 null as parent,                        
 T1.IndigoClientId as [RequestVariable!1!IndigoClientId],                        
 T1.Identifier as [RequestVariable!1!Identifier],                        
 T1.Status as [RequestVariable!1!Status],                        
 T1.ContactId as [RequestVariable!1!PrimaryCRMContactId],                        
 IsNull(T1.PrimaryContact,'') as [RequestVariable!1!PrimaryContact],                        
 IsNull(T1.EmailAddress,'') as [RequestVariable!1!EmailAddress],                        
 IsNull(T1.SIB,'') as [RequestVariable!1!SIB],    --Company SIB              
 IsNull(T1.FSA,'') as [RequestVariable!1!FSA],    --Company FSA              
 IsNull(@GroupFSA,'') as [RequestVariable!1!GroupFSA],    --Group FSA              
 IsNull(@FSAReference,'') as [RequestVariable!1!AdviserFSA],  --Adviser FSA              
 IsNull(T1.Postcode,'') as [RequestVariable!1!Postcode],  --Company Postcode              
 IsNull(@AdviserPostCode,'') as [RequestVariable!1!AdviserPostcode], --Adviser Postcode      
 ISNull(@CertificatePostCode, '') as [RequestVariable!1!CertificatePostCode], --Certificate PostCode      
 ISNull(@AdviserName,'') as [RequestVariable!1!AdviserName], --based on @PortalCRMContactId      
 ISNULL(@PortalCRMContactId,0) as [RequestVariable!1!PortalCRMContactId],      
    
 IsNull(@OrderAsLittleEndian, 0) as [RequestVariable!1!OrderAsLittleEndian],  --Change X509 Subject data order    
                        
 T2.PolicyBusinessId as [RequestVariable!1!PolicyBusinessId],                        
 IsNull(T2.PolicyNumber,'') as [RequestVariable!1!PolicyNumber],                
 IsNull(T16.PortalReference,'') AS [RequestVariable!1!PortalReference],                        
 IsNull(T2.PolicyStartDate,'') as [RequestVariable!1!PolicyStartDate],                        
 T2.PractitionerId as [RequestVariable!1!SellingPractitionerId],                        
 T4.RefProdProviderId as [RequestVariable!1!RefProdProviderId],                        
 IsNull(T8.CorporateName,'') as [RequestVariable!1!ProviderName],                        
 T6.RefPlanTypeId as [RequestVariable!1!RefPlanTypeId],                        
 IsNull(T6.PlanTypeName,'') as [RequestVariable!1!PlanTypeName],                        
                        
 IsNull(T10.ProdSubTypeId,0) As [RequestVariable!1!ProdSubTypeId],              
 ISNULL(T14.ProdSubTypeName, '') As [RequestVariable!1!ProdSubTypeName],                        
                        
 T13.CRMContactId as [RequestVariable!1!PolicyOwnerCRMContactId],                        
 IsNull(T13.FirstName + ' ' + T13.LastName,'') as [RequestVariable!1!PolicyOwner],                        
                        
 IsNull(T9.PostUrl,'') as [RequestVariable!1!PostUrl],
IsNull(T9.ReEncodeResponseTo,'') as [RequestVariable!1!ReEncodeResponseTo], 
 IsNull(T9.OrigoResponderId,'') as [RequestVariable!1!OrigoResponderId],                        
                        
 IsNull(T10.OrigoProductType,'') as [RequestVariable!1!OrigoProductType],                        
 IsNull(T10.OrigoProductVersion,'') as [RequestVariable!1!OrigoProductVersion],                        
                        
 T9.AuthenticationType as [RequestVariable!1!AuthenticationType],                        

 Case When T9.AuthenticationType = 0 Then                  
  Case
   --L&G in IO Production environment
   When (@ReturnUserGuid = 0 And T4.RefProdProviderId = 199) Then 'Basic ' + (dbo.text_to_base64(IsNull(T11.UserName,'') + ':' + IsNull(dbo.FnCustomDecryptPortalPassword(T11.Password2),''))) 
   --L&G in their own environment
   When (@ReturnUserGuid = 1 And T4.RefProdProviderId = 199) Then 'Basic ' + (dbo.text_to_base64(Lower(@UserGuid))) 
  Else                  
   IsNull(T11.UserName,'')                        
  End
 Else                        
  ''                        
 End as [RequestVariable!1!PortalUserName],                        
                        
 Case When T9.AuthenticationType = 0 Then                   
  Case                   
   When T4.RefProdProviderId = 199 Then ''    --L&G                  
  Else                  
   IsNull(dbo.FnCustomDecryptPortalPassword(T11.Password2),'')                  
  End                  
 Else                        
  ''                    
 End as [RequestVariable!1!PortalPassword],                        
                        
 Case When T9.AuthenticationType = 0 Then                        
  Case                         
   When T4.RefProdProviderId = 84 Then 'CMFS-USERNAME'   --HBos - CM                        
   When T4.RefProdProviderId = 323 Then 'userid'    --Scot Mutual                  
   When T4.RefProdProviderId = 199 Then 'Authorization'    --L&G
   When T4.RefProdProviderId = 183 Then 'userid' --JamesHay
  Else                        
   'USERNAME'        --Skandia                        
  End                        
 Else                        
  ''                        
 End As [RequestVariable!1!PortalUserNameTag],                        
                      
 Case When T9.AuthenticationType = 0 Then                        
  Case                         
   When T4.RefProdProviderId = 84 Then 'CMFS-PASSWORD'   --HBos - CM                        
   When T4.RefProdProviderId = 323 Then 'password'    --Scot Mutual                  
   When T4.RefProdProviderId = 199 Then ''    --L&G        
   When T4.RefProdProviderId = 183 Then 'password' --JamesHay          
  Else                        
  'PASSWORD'        --Skandia                        
  End                        
 Else                        
  ''                        
 End As [RequestVariable!1!PortalPasswordTag],   

 IsNull(T11.Passcode,'') As [RequestVariable!1!PortalPasscode],
                        
 T9.AllowRetry AS [RequestVariable!1!AllowRetry],                        
     IsNull(T9.RetryDelay, 0) AS [RequestVariable!1!RetryDelay],                        
 NEWID() AS [RequestVariable!1!GUID],                        
 Convert(varchar(24),getdate(),126) + '0' AS [RequestVariable!1!Timestamp],                        
 IsNull(T10.ValuationXSLId,0) AS [RequestVariable!1!ValuationXSLId],                        
 IsNull(T15.XSL,'') AS [RequestVariable!1!XSL]                
                
                        
From PolicyManagement.dbo.TPolicyBusiness T2                        
                        
Inner Join PolicyManagement.dbo.TPolicyDetail T3                        
On T2.PolicyDetailId = T3.PolicyDetailId                        
                        
Inner Join PolicyManagement.dbo.TPlanDescription T4                        
On T3.PlanDescriptionId = T4.PlanDescriptionId                        
                        
Inner Join PolicyManagement.dbo.TRefPlanType2ProdSubType T5                        
On T4.RefPlanType2ProdSubTypeId = T5.RefPlanType2ProdSubTypeId                        
                        
Inner Join PolicyManagement.dbo.TRefPlanType T6                        
On T5.RefPlanTypeId = T6.RefPlanTypeId                        
                        
Inner Join PolicyManagement.dbo.TRefProdProvider T7                        
On T4.RefProdProviderId = T7.RefProdProviderId                        
                        
Inner Join CRM.dbo.TCRMContact T8                        
On T7.CRMContactId = T8.CRMContactId                        
                        
Inner Join Administration.dbo.TIndigoClient T1                        
On T1.IndigoClientId = T2.IndigoClientId                        
                        
Inner Join PolicyManagement.dbo.TValProviderConfig T9                        
On T9.RefProdProviderId = @RefProdProviderId                     
                        
Left JOIN TProdSubType T14 on T14.ProdSubTypeId = T5.ProdSubTypeId                        
                      
Inner Join PolicyManagement.dbo.TValGating T10                        
On T10.RefProdproviderId = @RefProdProviderId And T10.RefPlanTypeId = T6.RefPlanTypeId                        
And (IsNull(T10.ProdSubTypeId,0) = IsNull(T14.ProdSubTypeId,0))                        
                        
Left Join PolicyManagement.dbo.TValPortalSetup T11                        
On T11.CRMContactId = @PortalCRMContactId                        
And T11.RefProdproviderId = T10.RefProdproviderId                        
                        
Inner Join PolicyManagement.dbo.TPolicyOwner T12                        
On T12.PolicyDetailId = T2.PolicyDetailId                        
                        
Inner Join CRM.dbo.TCRMContact T13                        
On T13.CRMContactId = T12.CRMContactId                        
                        
Left Join PolicyManagement.dbo.TValuationXSL T15                        
On T15.ValuationXSLId = T10.ValuationXSLId                
                
Left Join PolicyManagement..TPolicyBusinessExt T16                
On T16.PolicyBusinessId = T2.PolicyBusinessId                
                        
Where T2.PolicyBusinessId = @PolicyBusinessId                        
                        
FOR XML EXPLICIT   

GO
