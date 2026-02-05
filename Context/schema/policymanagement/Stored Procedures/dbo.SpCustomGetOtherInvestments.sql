
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomGetOtherInvestments]	
	@PartyId bigint,
	@RelatedPartyId bigint = null,
	@TenantId bigint	
AS	

--DECLARE @PartyId BIGINT = 4670733
--DECLARE @RelatedPartyId BIGINT = 4670731
--DECLARE @TenantId BIGINT = 10155


 DECLARE @PartyPlans TABLE 
( 
 PolicyBusinessId bigint not null,
 PolicyDetailId bigint not null
)


INSERT INTO @PartyPlans
 SELECT DISTINCT pb.PolicyBusinessId, pb.PolicyDetailId
 FROM 
  PolicyManagement..TPolicyOwner PO 
		JOIN  PolicyManagement..TPolicyDetail Pd WITH(NOLOCK) ON Pd.PolicyDetailId = po.PolicyDetailId
		JOIN PolicyManagement..TPolicyBusiness Pb WITH(NOLOCK) ON Pb.PolicyDetailId = Pd.PolicyDetailId		
		JOIN PolicyManagement..TPlanDescription PDesc WITH(NOLOCK)  ON PDesc.PlanDescriptionId = Pd.PlanDescriptionId   	
		JOIN factfind..TRefPlanTypeToSection PTS WITH(NOLOCK) ON PTS.RefPlanType2ProdSubTypeId = PDesc.RefPlanType2ProdSubTypeId  
		JOIN PolicyManagement..TStatusHistory Sh WITH(NOLOCK) ON Sh.PolicyBusinessId = Pb.PolicyBusinessId AND CurrentStatusFg = 1                                  
		JOIN PolicyManagement..TStatus Status WITH(NOLOCK) ON Status.StatusId = Sh.StatusId AND Status.IntelligentOfficeStatusType <> 'Deleted'  
  WHERE po.CRMContactId in (@PartyId, @RelatedPartyId) and pd.IndigoClientId = @TenantId     
  AND  PTS.Section = 'Other Investments'


SELECT
 P.PolicyBusinessId,   
 tpi.ContributionThisTaxYearFg,
 tpi.MonthlyIncome,
 Pb.LowMaturityValue,  
 Pb.MediumMaturityValue,  
 Pb.HighMaturityValue, 
 pb.ProjectionDetails,
 Pb.[IsGuaranteedToProtectOriginalInvestment],  
 pt.InTrust,
 pt.ToWhom,
 Pbe.InterestRate
FROM   
 @PartyPlans p       
  JOIN  PolicyManagement..TPolicyBusiness Pb WITH(NOLOCK) ON Pb.PolicyBusinessId = p.PolicyBusinessId      
  JOIN  PolicyManagement..TPolicyBusinessExt Pbe WITH(NOLOCK) ON Pbe.PolicyBusinessId = p.PolicyBusinessId      
  LEFT JOIN factfind..TOtherInvestmentsPlanFFExt tpi WITH(NOLOCK) ON tpi.PolicyBusinessId = p.PolicyBusinessId  
  LEFT JOIN policymanagement..TProtection  pt WITH(NOLOCK) ON pt.PolicyBusinessId = p.PolicyBusinessId 
