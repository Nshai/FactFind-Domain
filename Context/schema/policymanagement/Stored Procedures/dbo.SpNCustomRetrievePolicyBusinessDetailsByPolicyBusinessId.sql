SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrievePolicyBusinessDetailsByPolicyBusinessId]                  
@PolicyBusinessId bigint,@Userid bigint                
AS                
                
DECLARE @CurrentStatusId bigint                  
DECLARE @LifeCycleId bigint                  
DECLARE @LifeCycleStepId bigint                  
DECLARE @RoleId bigint                  
DECLARE @RefProdProviderId bigint            
DECLARE @CurrentStatus varchar(50)                
DECLARE @RightMask int            
                  
                  
SET @CurrentStatusId = (SELECT StatusId FROM TStatusHistory WHERE PolicyBusinessId = @PolicyBusinessId AND CurrentStatusFg = 1)                  
SET @LifeCycleId = (SELECT LifeCycleId FROM TPolicyBusiness WHERE PolicyBusinessId = @PolicyBusinessId)                  
SET @LifeCycleStepId = (SELECT LifeCycleStepId FROM TLifeCycleStep WHERE LifeCycleId = @LifeCycleId AND StatusId = @CurrentStatusId)                  
SET @RoleId = (SELECT ActiveRole FROM Administration..TUser WHERE UserId = @UserId)                  
SET @CurrentStatus=(SELECT [Name] FROM TStatus WHERE StatusId=@CurrentStatusId)                
SET @RefProdProviderId=(SELECT PDES.RefProdProviderId FROM PolicyManagement..TPolicyBusiness PB WITH(NOLOCK)            
      JOIN TPolicyDetail PD WITH(NOLOCK) ON PB.PolicyDetailId=PD.PolicyDetailId              
      JOIN TPlanDescription PDES WITH(NOLOCK) ON PD.PlanDescriptionId=PDES.PlanDescriptionId WHERE PB.PolicyBusinessId=@PolicyBusinessId)            
SET @RightMask=(SELECT ISNULL(SuperUser,0) FROM Administration..TUser WHERE UserId=@UserId)            
                  
BEGIN                  
  --PolicyBusiness                
  SELECT A.PolicyBusinessId,A.PolicyDetailId,ISNULL(PolicyNumber,'')'PolicyNumber',A.PractitionerId,                
 ISNULL(ReplaceNotes,'')'ReplaceNotes',ISNULL(A.TnCCoachId,0)'TnCCoachId',AdviceTypeId,                
 BestAdvicePanelUsedFG,WaiverDefermentPeriod,A.IndigoClientId,SwitchFG,                
 '' + ISNULL(CONVERT(VARCHAR(24),TotalRegularPremium),'0.00')'TotalRegularPremium','' + ISNULL(CONVERT(VARCHAR(24),TotalLumpSum),'0.00')'TotalLumpSum',                
 ISNULL(CONVERT(VARCHAR(24),A.MaturityDate,103),'')'MaturityDate',                
 ISNULL(CONVERT(VARCHAR(24),PolicyStartDate,103),'')'PolicyStartDate',ISNULL(PremiumType,'')'PremiumType',                
 ISNULL(A.AgencyNumber,'')'AgencyNumber',A.OffPanelFg,ISNULL(BaseCurrency,'GBP')'BaseCurrency',                
 ISNULL(CONVERT(VARCHAR(24),ExpectedPaymentDate,103),'')'ExpectedPaymentDate',                
 ISNULL(ProductName,'')'ProductName',SequentialRef,A.ConcurrencyId,                
 ISNULL(A.ProviderAddress,'')'ProviderAddress',             
 PA.AddressId 'ProviderAddressId',               
 C.FirstName + ' ' + C.LastName 'PractitionerName',                
 ISNULL(F.FirstName,'') + CASE ISNULL(F.FirstName,'') WHEN '' THEN '' ELSE ' ' END + ISNULL(F.LastName,'') 'TnCCoachName',                
 PD.PlanDescriptionId,ISNULL(PD.TermYears,0)'TermYears',ISNULL(PD.WholeOfLifeFg,0)'WholeOfLifeFg',                
 ISNULL(PD.LetterOfAuthorityFg,0)'LetterOfAuthorityFg',ISNULL(PD.ContractOutOfSERPSFg,0)'ContractOutOfSERPSFg',                
 ISNULL(CONVERT(VARCHAR(24),PD.ContractOutStartDate,103),'')'ContractOutStartDate',                
 ISNULL(CONVERT(VARCHAR(24),PD.ContractOutStopDate,103),'')'ContractOutStopDate',                
 ISNULL(PD.AssignedCRMContactId,0)'AssignedCRMContactId',ISNULL(CONVERT(VARCHAR(24),PD.JoiningDate,103),'')'JoiningDate',                
 ISNULL(CONVERT(VARCHAR(24),PD.LeavingDate,103),'')'LeavingDate',PDES.RefProdProviderId,@CurrentStatusId 'StatusId',@CurrentStatus 'Status',                
 BT.[Description] 'BandingDescriptor',ISNULL(PBE.PortalReference,'')'PortalReference',                
 ISNULL(PDES.SchemeOwnerCRMContactId,0)'SchemeOwnerCRMContactId',ISNULL(PDES.SchemeStatus,'')'SchemeStatus',ISNULL(PDES.SchemeNumber,'')'SchemeNumber',                
 ISNULL(PDES.SchemeName,'')'SchemeName',ISNULL(CONVERT(VARCHAR(24),PDES.SchemeStatusDate,103),'')'SchemeStatusDate',                
 ISNULL(CONVERT(VARCHAR(24),PD.JoiningDate,103),'')'JoiningDate',ISNULL(CONVERT(VARCHAR(24),PD.LeavingDate,103),'')'LeavingDate',          
 ISNULL(pbe.ReportNotes,'')'ReportNotes',      
 ISNULL(pbe.MigrationRef, '')'MigrationRef',    
 CASE @RightMask           
 WHEN 1 THEN 16          
 ELSE 0          
 END as 'RightMask',  
 ISNULL(ADV.AdviceCaseId,0)'AdviceCaseId',ISNULL(ADV.CaseName,'')'CaseName',ISNULL(ADV.CaseRef,'')'CaseRef'     
                
                
                 
  FROM TPolicyBusiness A WITH(NOLOCK)                
  JOIN TPolicyBusinessExt PBE WITH(NOLOCK) ON A.PolicyBusinessId=PBE.PolicyBusinessId                
  JOIN Commissions..TBandingTemplate BT WITH(NOLOCK) ON PBE.BandingTemplateId=BT.BandingTemplateId                
  JOIN TPolicyDetail PD WITH(NOLOCK) ON A.PolicyDetailId=PD.PolicyDetailId                
  JOIN TPlanDescription PDES WITH(NOLOCK) ON PD.PlanDescriptionId=PDES.PlanDescriptionId                  
  JOIN CRM..TPractitioner B WITH(NOLOCK) ON A.PractitionerId=B.PractitionerId                
  JOIN CRM..TCRMContact C WITH(NOLOCK) ON B.CRMContactId=C.CRMContactId                
  LEFT JOIN Compliance..TTnCCoach D WITH(NOLOCK) ON A.TnCCoachId=D.TnCCoachId                
  LEFT JOIN Administration..TUser E WITH(NOLOCK) ON D.UserId=E.UserId                
  LEFT JOIN CRM..TCRMContact F WITH(NOLOCK) ON E.CRMCOntactId=F.CRMCOntactId            
  LEFT JOIN(            
  SELECT (ISNULL(B.AddressLine1,'')               
   + CASE WHEN ISNULL(B.AddressLine2,'') <> '' THEN ', ' + B.AddressLine2 ELSE '' END               
   + CASE WHEN ISNULL(B.AddressLine3,'') <> '' THEN ', ' + B.AddressLine3 ELSE '' END               
   + CASE WHEN ISNULL(B.AddressLine4,'') <> '' THEN ', ' + B.AddressLine4 ELSE '' END               
   + CASE WHEN ISNULL(B.CityTown,'') <> '' THEN ', ' + B.CityTown ELSE '' END               
   + CASE WHEN ISNULL(B.PostCode,'') <> '' THEN ', ' + B.PostCode ELSE '' END               
   + CASE WHEN ISNULL(tel.Value,'') <> '' THEN ', Tel:' + tel.Value ELSE '' END              
   + CASE WHEN ISNULL(fax.Value,'') <> '' THEN ', Fax:' + fax.Value ELSE '' END) AS 'ProviderAddress',A.AddressId             
  FROM TRefProdProvider RPP WITH(NOLOCK)             
  JOIN CRM..TAddress A WITH(NOLOCK) ON RPP.CRMContactId=A.CRMContactId -- AND A.DefaultFg=1          
  JOIN CRM..TAddressStore B ON A.AddressStoreId=B.AddressStoreId               
  LEFT JOIN CRM..TContact tel ON tel.CRMContactId = a.CRMContactId AND tel.RefContactType = 'Telephone' and tel.DefaultFg = 1              
  LEFT JOIN CRM..TContact fax ON fax.CRMContactId = a.CRMContactId AND fax.RefContactType = 'Fax' and fax.DefaultFg = 1              
  WHERE RPP.RefProdProviderId=@RefProdProviderId            
      )PA ON A.ProviderAddress=PA.ProviderAddress   
  LEFT JOIN  
  (  
 SELECT TOP 1 A.PolicyBusinessId,B.AdviceCaseId,B.CaseName,B.CaseRef  
 FROM CRM..TAdviceCasePlan A  
 JOIN CRM..TAdviceCase B ON A.AdviceCaseId=B.AdviceCaseId  
 WHERE A.PolicyBusinessId=@PolicyBusinessId  
 ORDER BY AdviceCaseId ASC  
  )ADV ON A.PolicyBusinessId=ADV.PolicyBusinessId              
                
  WHERE A.PolicyBusinessId=@PolicyBusinessId                 
                
                
  --Owners                
  SELECT A.PolicyBusinessId,B.PolicyOwnerId,C.CRMContactId,CASE ISNULL(C.PersonId,0)                
  WHEN 0 THEN C.CorporateName                
  ELSE C.FirstName + ' ' + C.LastName                
  END AS 'ClientName'                
  FROM TPolicyBusiness A WITH(NOLOCK)                
  JOIN TPolicyOwner B WITH(NOLOCK) ON A.PolicyDetailId=B.PolicyDetailId                
  JOIN CRM..TCRMContact C WITH(NOLOCK) ON B.CRMContactId=C.CRMContactId                
  WHERE A.PolicyBusinessId=@PolicyBusinessId                  
  ORDER BY B.PolicyOwnerId                
                  
                
--RefPlanAction stuff                
SELECT                
@PolicyBusinessId 'PolicyBusinessId',A.RefPlanActionStatusRoleId,B.Identifier,B.[Description]                
FROM TRefPlanActionStatusRole A                  
INNER JOIN TRefPlanAction B ON A.RefPlanActionId = B.RefPlanActionId                  
WHERE A.LifeCycleStepId = @LifeCycleStepId                  
AND A.RoleId = @RoleId                  
                
--PolicyNumber format                
SELECT A.PolicyBusinessId,PNF.PolicyNumberFormatId,PNF.UserFormat,PNF.Example,PNF.RegularExpression                
FROM TPolicyBusiness A                
JOIN TPolicyDetail PD ON A.PolicyDetailId=PD.PolicyDetailId                
JOIN TPlanDescription PDES ON PD.PlanDescriptionId=PDES.PlanDescriptionId                
JOIN TRefPlanType2ProdSubType RPT ON PDES.RefPlanType2ProdSubTypeId=RPT.RefPlanType2ProdSubTypeId                
JOIN TPolicyNumberFormat PNF ON PDES.RefProdProviderId=PNF.RefProdProviderId AND RPT.RefPlanTypeId=PNF.RefPlanTypeId and pnf.indigoclientid=A.indigoclientid               
WHERE A.PolicyBusinessId=@PolicyBusinessId          
    
          
                
                  
END                  
RETURN (0) 
GO
