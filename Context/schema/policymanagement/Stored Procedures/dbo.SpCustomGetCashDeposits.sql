
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomGetCashDeposits]	
	@PartyId bigint,
	@RelatedPartyId bigint = null,
	@TenantId bigint, 
	@CurrentUserDate datetime
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
  AND  PTS.Section = 'savings'


SELECT
 Pb.PolicyBusinessId,       
 PBE.InterestRate,
 CASE                                    
  WHEN ISNULL(Fund.FundValue, 0) != 0 THEN                      
   CASE               
    WHEN ISNULL(Fund.PriceChangeDate,@CurrentUserDate-10000)>ISNULL(Val.PlanValueDate,@CurrentUserDate-10000) THEN Fund.FundValue                                    
    WHEN ISNULL(Val.PlanValueDate,@CurrentUserDate-10000)>=ISNULL(Fund.PriceChangeDate,@CurrentUserDate-10000) THEN Val.PlanValue                      
   END                      
  WHEN Val.PlanValue IS NOT NULL THEN Val.PlanValue                                   
  ELSE 0                      
 END  CurrentValue, 
 pt.InTrust,
 pt.ToWhom,
 Val.PlanValueDate AS LastUpdatedAt
FROM   
 @PartyPlans pb              
 --JOIN  PolicyManagement..TPolicyDetail Pb WITH(NOLOCK) ON Pb.PolicyDetailId = pd.PolicyDetailId     
 LEFT JOIN Policymanagement..TPolicyBusinessExt PBE WITH(NOLOCK) ON PBE.PolicyBusinessId = pb.PolicyBusinessId 
 LEFT JOIN policymanagement..TProtection  pt WITH(NOLOCK) ON pt.PolicyBusinessId = pb.PolicyBusinessId 
  -- Latest valuation                                  
 LEFT JOIN (                                  
  SELECT                                   
	  PolicyBusinessId,     
	  PolicyManagement.dbo.[FnCustomGetLatestPlanValuationIdByValuationDate](PolicyBusinessId) AS PlanValuationId    
   FROM     
   @PartyPlans    
  ) AS LastVal ON LastVal.PolicyBusinessId = Pb.PolicyBusinessId    
   -- Join back to plan valuation using the latest date      
 LEFT JOIN PolicyManagement..TPlanValuation Val ON Val.PlanValuationId = LastVal.PlanValuationId    
 -- Fund Price                                  
 LEFT JOIN (                                  
  SELECT                                     
   PolicyBusinessId,    
   MAX(LastPriceChangeDate) AS PriceChangeDate,                                   
   SUM(ISNULL(CurrentPrice, 0) * ISNULL(CurrentUnitQuantity, 0)) AS FundValue                                  
  FROM                                  
   PolicyManagement..TPolicyBusinessFund WITH(NOLOCK)                                   
  WHERE     
   PolicyBusinessId IN (SELECT PolicyBusinessId FROM @PartyPlans)      
  GROUP BY     
   PolicyBusinessId) AS Fund ON Fund.PolicyBusinessId = Pb.PolicyBusinessId    