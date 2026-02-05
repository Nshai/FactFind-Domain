SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*###############################################################################  
  
Name          : dbo.SpNCustomRetrieveProtectionPlan   
Used From     : FactFindCorporateDataREpository.cs  
      
Modified By   : Ashok  
Modification  : To Show top-up plans only if the sellingadviser's group   
Summary   has 'ShowTopupsInFactFind' Preference in LegalPreference Table  
  
  
#################################################################################*/  
CREATE PROCEDURE [dbo].[SpNCustomRetrieveProtectionPlan]  
 @IndigoClientId bigint,      
 @FactFindId bigint      
AS     

Begin
SET NOCOUNT ON
DECLARE @CRMContactId bigint,@CRMContactType tinyint      
  
SELECT   
 @CRMContactId = CrmContactId1  
FROM   
 TFactFind  
WHERE   
 IndigoClientId = @IndigoClientId      
 AND FactFindId = @FactFindId    
   
 -- Client Type      
SELECT @CRMContactType = CRMContactType FROM CRM..TCRMContact WHERE CRMContactId = @CRMContactId      
  
-- Table for Plan Types Details      
DECLARE @PlanDescription TABLE  (      
 PolicyBusinessId bigint not null PRIMARY KEY,      
 PolicyDetailId bigint not null,      
 CRMContactId bigint not null,      
 CRMContactId2 bigint null,      
 [Owner] varchar(16) not null,      
 OwnerCount int not null,      
 RefPlanType2ProdSubTypeId bigint NOT NULL,  
 PlanType varchar(128) not null,      
 --FactFindSearchType varchar(64) not null,      
 RefProdProviderId bigint,      
 Provider varchar(128) not null,      
 PolicyNumber varchar(64) null,
 AgencyStatus varchar(50) null,
 StartDate datetime null,      
 MaturityDate datetime null,      
 StatusDate datetime not null,      
 Term tinyint null,          
 RegularPremium money null,      
 ActualRegularPremium money null,      
 TotalLumpSum money null,      
 TotalPremium money null,      
 Frequency varchar(32) null,      
 Valuation money null,      
 CurrentValue money null,      
 ValuationDate datetime,      
 ProductName varchar(255) null,      
 RefPlanTypeId bigint,      
 SellingAdviserId bigint,      
 SellingAdviserName varchar(255),      
 ConcurrencyId bigint null,  
 PlanStatus varchar(50) null,  
 SellingAdviserCRMContactId bigint,
 SequentialRef varchar(50) null
)      
   
-- Basic Plan Details      
INSERT INTO @PlanDescription      
SELECT      
 Pb.PolicyBusinessId,      
 Pd.PolicyDetailId,      
 POwn.CRMContactId,      
 POwn.CRMContactId2,      
 CASE POwn.OwnerCount      
  WHEN 1 THEN      
   CASE POwn.CRMContactId      
    WHEN @CRMContactId THEN 'Client 1'      
    ELSE 'Client 2'      
   END      
  ELSE 'Joint'          
 END,      
 POwn.OwnerCount,      
 PlanToProd.RefPlanType2ProdSubTypeId,  
 CASE       
  WHEN LEN(ISNULL(Pst.ProdSubTypeName, '')) > 0 THEN  PType.PlanTypeName + ' (' + Pst.ProdSubTypeName + ')'      
  ELSE PType.PlanTypeName      
 END,       
 Rpp.RefProdProviderId,  
 RppC.CorporateName,      
 Pb.PolicyNumber,
 Pbe.AgencyStatus,
 Pb.PolicyStartDate,      
 Pb.MaturityDate,      
 Sh.DateOfChange,      
 Pd.TermYears,      
 -- This is a fudge for one of the add/edit plan screens      
 CASE ISNULL(Contributions.Number, 0)      
  WHEN 1 THEN ISNULL(Pb.TotalLumpSum, 0) + ISNULL(Pb.TotalRegularPremium, 0)      
  ELSE ISNULL(Pb.TotalRegularPremium, 0)      
 END,      
 ISNULL(Pb.TotalRegularPremium, 0), -- Actual regular premium      
 ISNULL(Pb.TotalLumpSum, 0),      
 ISNULL(Pb.TotalLumpSum, 0) + ISNULL(Pb.TotalRegularPremium, 0),      
 Pb.PremiumType,      
 -- Valuation      
 Val.PlanValue,      
 -- CurrentValue      
 CASE      
  WHEN Fund.FundValue IS NOT NULL THEN Fund.FundValue      
  WHEN Val.PlanValue IS NOT NULL THEN Val.PlanValue      
  ELSE ISNULL(Pb.TotalLumpSum, 0)      
 END,      
 Val.PlanValueDate,      
 pb.ProductName,      
 pType.RefPlanTypeId,      
 pb.PractitionerId,      
 isnull(pracCRM.FirstName,'') + ' ' + isnull(pracCRM.LastName,''),      
 pb.ConcurrencyId,  
 [Status].Name,  
 prac.CRMContactId,
 pb.SequentialRef
FROM (      
 SELECT       
  COUNT(PolicyOwnerId) AS OwnerCount,  
  PolicyDetailId,  
  MIN(CRMCOntactId) AS CRMContactId,      
  CASE MAX(CRMContactId)      
   WHEN MIN(CRMContactId) THEN NULL      
   ELSE MAX(CRMContactId)      
  END AS CRMContactId2      
 FROM      
  PolicyManagement..TPolicyOwner WITH(NOLOCK)      
 WHERE      
  CRMContactId = @CRMContactId      
 GROUP BY      
  PolicyDetailId      
 ) AS POwn  
 JOIN PolicyManagement..TPolicyDetail Pd  WITH(NOLOCK) ON Pd.PolicyDetailId = POwn.PolicyDetailId      
 JOIN PolicyManagement..TPolicyBusiness Pb WITH(NOLOCK)  ON Pb.PolicyDetailId = Pd.PolicyDetailId
 LEFT JOIN PolicyManagement.dbo.TPolicyBusinessExt Pbe WITH(NOLOCK)  ON Pbe.PolicyBusinessId = Pb.PolicyBusinessId
 JOIN PolicyManagement..TStatusHistory Sh WITH(NOLOCK) On Sh.PolicyBusinessId = Pb.PolicyBusinessId AND CurrentStatusFg = 1      
 JOIN PolicyManagement..TStatus Status WITH(NOLOCK) ON Status.StatusId = Sh.StatusId AND Status.IntelligentOfficeStatusType IN ('In Force', 'Paid Up')       
 JOIN PolicyManagement..TPlanDescription PDesc WITH(NOLOCK) ON PDesc.PlanDescriptionId = Pd.PlanDescriptionId       
 JOIN PolicyManagement..TRefPlanType2ProdSubType PlanToProd WITH(NOLOCK) ON PlanToProd.RefPlanType2ProdSubTypeId = PDesc.RefPlanType2ProdSubTypeId       
 LEFT JOIN PolicyManagement..TProdSubType Pst WITH(NOLOCK) ON Pst.ProdSubTypeId = PlanToProd.ProdSubTypeId      
 JOIN PolicyManagement..TRefPlanType PType WITH(NOLOCK) ON PType.RefPlanTypeId = PlanToProd.RefPlanTypeId      
 JOIN PolicyManagement..TRefProdProvider Rpp WITH(NOLOCK) ON Rpp.RefProdProviderId = PDesc.RefProdProviderId       
 JOIN [CRM]..TCRMContact RppC WITH(NOLOCK) ON RppC.CRMContactId = Rpp.CRMContactId      
 JOIN [CRM]..TPractitioner prac WITH (NOLOCK) ON prac.PractitionerId = pb.PractitionerId      
 JOIN [CRM]..TCRMContact pracCRM WITH (NOLOCK) ON pracCRM.CRMContactId = prac.CRMContactId        
 -- Latest valuation      
 LEFT JOIN (      
  SELECT       
   PV.PolicyBusinessId, Max(PV.PlanValuationId) AS PlanValuationId      
  FROM       
   PolicyManagement..TPlanValuation PV  
   JOIN @PlanDescription PD ON PD.PolicyBusinessId = PV.PolicyBusinessId  
  GROUP BY       
   PV.PolicyBusinessId) AS LastVal ON LastVal.PolicyBusinessId = Pb.PolicyBusinessId        
 LEFT JOIN PolicyManagement..TPlanValuation Val ON Val.PlanValuationId = LastVal.PlanValuationId      
 -- Fund Price      
 LEFT JOIN (      
  SELECT         
   PBF.PolicyBusinessId,      
   SUM(ISNULL(CurrentPrice, 0) * ISNULL(CurrentUnitQuantity, 0)) AS FundValue      
  FROM      
   PolicyManagement..TPolicyBusinessFund PBF WITH(NOLOCK)       
   JOIN @PlanDescription PD ON PD.PolicyBusinessId = PBF.PolicyBusinessId  
  GROUP BY PBF.PolicyBusinessId) AS Fund ON Fund.PolicyBusinessId = Pb.PolicyBusinessId      
 -- Look for single contribution      
 LEFT JOIN (      
  SELECT      
   PMI.PolicyBusinessId,      
   COUNT(*) AS Number      
  FROM      
   PolicyManagement..TPolicyMoneyIn PMI WITH(NOLOCK)          
   JOIN @PlanDescription PD ON PD.PolicyBusinessId = PMI.PolicyBusinessId  
  GROUP BY      
   PMI.PolicyBusinessId) AS Contributions ON Contributions.PolicyBusinessId = Pb.PolicyBusinessId      
  
-- Protection                                
SELECT DISTINCT  
 Pd.PolicyBusinessId as ProtectionPlansId,                               
 Pd.CRMContactId,   
 Pd.[Owner],    
 pd.SellingAdviserId,                          
 pd.SellingAdviserName,      
 Pd.RefProdProviderId,                                
 Pd.PolicyNumber,
 Pd.AgencyStatus,
 Pd.RefPlanType2ProdSubTypeId,                                  
 Pd.StartDate as ProtectionStartDate,     
 Pd.MaturityDate,                                
 Pd.RegularPremium,                                
 ISNULL(Pd.Frequency, Yf.FrequencyName) AS PremiumFrequency,                          
 GI.SumAssured,  
 -- Just take majority of benefits from the 1st life (data should be the same for 2nd for the fields that FF cares about)  
 B1.BenefitAmount,                                
 B1.RefFrequencyId AS BenefitFrequencyId,                                 
 P.CriticalIllnessSumAssured as CriticalIllnessAmount,         
 P.LifeCoverSumAssured AS LifeCoverAmount,                         
 AL1.PartyId AS LifeAssuredId,                                
 B1.BenefitDeferredPeriod,                            
 B1.RefBenefitPeriodId,         
 P.PaymentBasisId AS RefPaymentBasisId,                       
 P.InTrust AS AssignedInTrust,  
 pd.ConcurrencyId,  
 Pd.PlanStatus,
 B1.OtherBenefitPeriodText,  
 pd.ProductName,
 pd.SequentialRef
FROM                                
 @PlanDescription Pd    
 -- Topups      
  JOIN (      
   SELECT PolicyDetailId, MIN(PolicyBusinessId) AS MainPlanId FROM PolicyManagement..TPolicyBusiness       
   WHERE PolicyDetailId IN (SELECT PolicyDetailId FROM @PlanDescription)      
   GROUP BY PolicyDetailId      
  ) AS Topups ON Topups.PolicyDetailId = Pd.PolicyDetailId                                  
 JOIN TRefPlanTypeToSection PTS WITH(NOLOCK) ON PTS.RefPlanType2ProdSubTypeId = Pd.RefPlanType2ProdSubTypeId  
 -- Protection details should always be available but...  
 LEFT JOIN PolicyManagement..TProtection P WITH(NOLOCK) ON P.PolicyBusinessId = Pd.PolicyBusinessId                                
 LEFT JOIN PolicyManagement..TGeneralInsuranceDetail GI WITH(NOLOCK) ON GI.ProtectionId = P.ProtectionId AND GI.RefInsuranceCoverCategoryId = 5 -- Payment Protection  
 -- Life assured 1  
 LEFT JOIN PolicyManagement..TAssuredLife AL1 WITH(NOLOCK) ON AL1.ProtectionId = P.ProtectionId AND AL1.OrderKey = 1   
 LEFT JOIN PolicyManagement..TBenefit B1 WITH(NOLOCK) ON B1.BenefitId = AL1.BenefitId  
 -- Your Contribution                                
 LEFT JOIN (        
  SELECT   
   MIN(A.PolicyMoneyInId) AS PolicyMoneyInId,  
   A.PolicyBusinessId        
  FROM   
   Policymanagement..TPolicyMoneyIn A WITH(NOLOCK)        
   JOIN @PlanDescription Pd ON Pd.PolicyBusinessId=A.PolicyBusinessId        
  WHERE   
   A.RefContributorTypeId=1        
  GROUP BY   
   A.PolicyBusinessId) AS YcMin ON Pd.PolicyBusinessId=YcMin.PolicyBusinessId     
 LEFT JOIN Policymanagement..TPolicyMoneyIn Yc WITH(NOLOCK) ON Yc.PolicyMoneyInId=YcMin.PolicyMoneyInId        
 LEFT JOIN Policymanagement..TRefContributorType Yct WITH(NOLOCK) ON Yct.RefContributorTypeId = Yc.RefContributorTypeId AND Yct.RefContributorTypeName = 'Self'                                
 LEFT JOIN Policymanagement..TRefFrequency Yf WITH(NOLOCK) ON Yf.RefFrequencyId=Yc.RefFrequencyId    
 JOIN Administration..TUser as UserDetails ON UserDetails.CRMContactId = pd.SellingAdviserCRMContactId  
 LEFT JOIN Administration..TLegalEntityPreference as Preference ON Preference.PreferenceName = 'ShowTopupsInFactFind'   
 AND preference.GroupId = UserDetails.GroupId                                                     
WHERE   
 PTS.Section = 'Protection'  
 AND @CRMContactType = 3    
 --Include Top UP's  
 AND (Topups.MainPlanId = Pd.PolicyBusinessId OR Preference.PreferenceValue = 'True')     

 SET NOCOUNT OFF
 End
 GO
