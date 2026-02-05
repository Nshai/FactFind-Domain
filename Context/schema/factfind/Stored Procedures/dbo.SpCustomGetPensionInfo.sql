SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomGetPensionInfo]	
	@PartyId bigint,
	@RelatedPartyId bigint = null,
	@TenantId bigint,
	@PlanTypeDescription varchar(255)	
AS	
Begin

--DECLARE @PartyId BIGINT = 4670733
--DECLARE @RelatedPartyId BIGINT = 4670731
--DECLARE @TenantId BIGINT = 10155
--DECLARE @PlanTypeDescription NVARCHAR(255) = 'Final Salary Schemes'

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
		JOIN TRefPlanTypeToSection PTS WITH(NOLOCK) ON PTS.RefPlanType2ProdSubTypeId = PDesc.RefPlanType2ProdSubTypeId  
		JOIN PolicyManagement..TStatusHistory Sh WITH(NOLOCK) ON Sh.PolicyBusinessId = Pb.PolicyBusinessId AND CurrentStatusFg = 1                                  
		JOIN PolicyManagement..TStatus Status WITH(NOLOCK) ON Status.StatusId = Sh.StatusId AND Status.IntelligentOfficeStatusType <> 'Deleted'  
  WHERE po.CRMContactId in (@PartyId, @RelatedPartyId) and pd.IndigoClientId = @TenantId     
  AND  PTS.Section = @PlanTypeDescription
  


SELECT
 Pd.PolicyBusinessId,                                
 coalesce(ext1.Employer,ext2.Employer) as Employer,    
 tpi.SRA as StandardRetirementAge,                                
 tpi.PensionableSalary,
 tpi.AccrualRate as AccuralRate ,                                
 tpi.ExpectedYearsOfService, 
 tpi.IsIndexed ,  
 tpi.IsCurrent as IsPreserved,
 tpi.LifetimeAllowanceUsed,
 tpi.EmployerContributionDetail,
 tpi.IsLifeStylingStrategy,
 tpi.LifeStylingStrategyDetail,
 tpi.YearsPurchaseAvailability,
 tpi.YearsPurchaseAvailabilityDetails,
 tpi.AffinityContributionAvailability,
 tpi.AffinityContributionAvailabilityDetails 
FROM   
 @PartyPlans pd              
 LEFT JOIN PolicyManagement..TPensionInfo tpi WITH(NOLOCK) ON tpi.PolicyBusinessId = pd.PolicyBusinessId 
 LEFT JOIN TFinalSalaryPensionsPlanFFExt ext1 WITH(NOLOCK) ON ext1.PolicyBusinessId = pd.PolicyBusinessId  
 LEFT JOIN TMoneyPurchasePensionPlanFFExt ext2 WITH(NOLOCK) ON ext2.PolicyBusinessId = pd.PolicyBusinessId 

End
GO
