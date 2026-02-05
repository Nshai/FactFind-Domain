SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpCustomGetIncomeDataForAuthor]
@CRMContactId bigint,
@UserId bigint

AS

declare @cid1 bigint, @cid2 bigint
declare @MonthlyIncome money, @MonthlyExpenditure money, @TotalProtectionRegularContributions money
declare @IncludeTopups bit, @LegalEntityId bigint, @IndigoClientId bigint

declare @income TABLE (
 CRMContactId1 bigint, 
 CRMContactId2 bigint, 
 MonthlyIncome money, IsIncomeChangeIncluded bit, IsIncomeChangeExpected bit, IsIncomeRiseExpected bit, IncomeChangeAmount money, RevisedMonthlyIncome money,  
 MonthlyExpenditure money, IsExpenditureChangeIncluded bit, IsExpenditureChangeExpected bit, IsExpenditureRiseExpected bit, ExpenditureChangeAmount money, RevisedMonthlyExpenditure money,  
 IsNonEssentialRemoved bit, NonEssentialMonthlyExpediture money, IsLiabilityExpenditureConsolidated bit, ConsolidatedAmount money,  
 IsProtectionRebroked bit, ProtectionAmount money  
 )  
  
  
  
SELECT @LegalEntityId = Administration.dbo.FnGetLegalEntityIdForUser(@UserId)  
SELECT @IncludeTopups = CAST(ISNULL(Administration.dbo.FnCustomGetGroupPreference(@LegalEntityId, 'ShowTopupsInFactFind'), 0) AS bit)    
SELECT @IndigoClientId = (SELECT IndClientId FROM CRM..TCRMContact WHERE CRMContactId = @CRMContactId)  
  
SELECT @cid1 = CRMContactId1,  @cid2 = CRMContactId2    
FROM TFactFind f    
WHERE (CRMContactId1 = @CRMContactId OR CRMContactId2 = @CRMContactId)    
  
INSERT INTO @income (CRMContactId1, CRMContactId2) VALUES (@cid1, @cid2)  
  
select @MonthlyIncome =   
ROUND(
  SUM (  
   case di.Frequency  
    WHEN 'weekly' THEN di.Amount * (52.0 / 12.0)  
    WHEN 'fortnightly' THEN di.Amount * (26.0 / 12.0)  
    WHEN 'four weekly' THEN di.Amount * (13.0 / 12.0)  
    WHEN 'monthly' THEN di.Amount  
    WHEN 'quarterly' THEN di.Amount / 3.0  
    WHEN 'half yearly' THEN di.Amount / 6.0  
    WHEN 'annually' THEN di.Amount / 12.0  
   end  
  ) ,2)
 FROM TDetailedincomebreakdown di  
 WHERE CRMContactId in (@cid1, @cid2)  
 and di.HasIncludeInAffordability =1

UPDATE @income    
 set     
 MonthlyIncome = @MonthlyIncome
 WHERE CRMContactId1 = @cid1 
  
UPDATE @income  
 set   
 IsIncomeChangeIncluded = a.IsIncomeChangeIncluded,  
 IsExpenditureChangeIncluded = a.IsExpenditureChangeIncluded,  
 IsNonEssentialRemoved = a.IsNonEssentialRemoved,  
 IsLiabilityExpenditureConsolidated = a.IsLiabilityExpenditureConsolidated,  
 IsProtectionRebroked = a.IsProtectionRebroked  
 FROM TAffordability a  
 WHERE a.CRMContactId = @cid1  


UPDATE @income  
 set  
 IsIncomeChangeExpected = i.IsChangeExpected,  
 IsIncomeRiseExpected = i.IsRiseExpected,  
 IncomeChangeAmount = i.ChangeAmount  
 FROM TIncome i  
 WHERE i.CRMContactId = @cid1  
   
UPDATE @income  
 set  
 IsExpenditureChangeExpected = e.IsChangeExpected,  
 IsIncomeRiseExpected = e.IsRiseExpected,  
 IncomeChangeAmount = e.ChangeAmount  
 FROM TExpenditure e  
 WHERE e.CRMContactId = @cid1  
   
   
IF (SELECT COUNT(1) FROM TExpenditure WHERE IsDetailed = 0 AND CRMContactId = @cid1) = 1   
 update @income   
 set MonthlyExpenditure = (select NetMonthlySummaryAmount FROM TExpenditure WHERE CRMContactId = @cid1)  
ELSE  
 update @income  
 set MonthlyExpenditure = (select SUM (NetMonthlyAmount) FROM TExpenditureDetail WHERE CRMContactId in (@cid1, @cid2))  
   
-- non-essential expediture   
IF (SELECT COUNT(1) FROM TExpenditure WHERE IsDetailed = 0 AND CRMContactId = @cid1) = 1   
 update @income set NonEssentialMonthlyExpediture = 0  
ELSE  
 update @income  
 set NonEssentialMonthlyExpediture = (  
  select   
  SUM (NetMonthlyAmount)   
  FROM TExpenditureDetail ed  
  JOIN TRefExpenditureType ret on ret.RefExpenditureTypeId = ed.RefExpenditureTypeId AND ret.RefExpenditureGroupId = 2  
  WHERE CRMContactId in (@cid1, @cid2)  
 )  
   
-- consolidated expediture   
IF (SELECT COUNT(1) FROM TExpenditure WHERE IsDetailed = 0 AND CRMContactId = @cid1) = 1   
 update @income set ConsolidatedAmount = 0  
ELSE  
 update @income  
 set ConsolidatedAmount = (  
  select   
  SUM (NetMonthlyAmount)   
  FROM TExpenditureDetail ed  
  WHERE CRMContactId in (@cid1, @cid2)  
  AND IsConsolidated = 1  
 )  
  
update @income   
 set RevisedMonthlyIncome =   
  case   
   when isnull(IsIncomeChangeIncluded, 0) = 0 then MonthlyIncome  
   when isnull(IsIncomeChangeExpected, 0) = 0 then MonthlyIncome  
   when IncomeChangeAmount IS NULL then MonthlyIncome  
   when IsIncomeRiseExpected = 1 then MonthlyIncome + IncomeChangeAmount  
   when IsIncomeRiseExpected = 0 then MonthlyIncome - IncomeChangeAmount  
  end  
    
update @income   
 set RevisedMonthlyExpenditure =   
  case   
   when isnull(IsExpenditureChangeIncluded, 0) = 0 then MonthlyExpenditure  
   when isnull(IsExpenditureChangeExpected, 0) = 0 then MonthlyExpenditure  
   when ExpenditureChangeAmount IS NULL then MonthlyExpenditure  
   when IsExpenditureRiseExpected = 1 then MonthlyExpenditure + ExpenditureChangeAmount  
   when IsExpenditureRiseExpected = 0 then MonthlyExpenditure - ExpenditureChangeAmount  
  end    
  
update @income  
 set RevisedMonthlyExpenditure =   
  case when ISNULL(IsNonEssentialRemoved,0) = 1 then  
   RevisedMonthlyExpenditure - NonEssentialMonthlyExpediture  
   else RevisedMonthlyExpenditure 
  end  
    
    
    
-- get protection plans, same logic as SpNCustomRetrieveAllPersonalData  
    
DECLARE @PlanList TABLE (BusinessId bigint PRIMARY KEY, DetailId bigint)      
INSERT INTO @PlanList      
SELECT DISTINCT     
      PB.PolicyBusinessId, PB.PolicyDetailId      
FROM                                
       PolicyManagement..TPolicyOwner PO WITH(NOLOCK)                                
       JOIN PolicyManagement..TPolicyBusiness PB WITH(NOLOCK) ON PB.PolicyDetailId = PO.PolicyDetailId      
WHERE                                
      CRMContactId IN (@cid1, @cid2)    
        
  
SELECT @TotalProtectionRegularContributions =                                  
      SUM(  
      CASE    
            WHEN ISNULL(pb.TotalRegularPremium,0) > 0 THEN pb.TotalRegularPremium                                
            ELSE ISNULL(pb.TotalLumpSum,0)                                
      END   
      )   
FROM                                  
      PolicyManagement..TPolicyDetail Pd WITH(NOLOCK)      
      JOIN PolicyManagement..TPolicyBusiness Pb WITH(NOLOCK)  ON Pb.PolicyDetailId = Pd.PolicyDetailId          
      -- Topups    
      JOIN (    
            SELECT PolicyDetailId, MIN(PolicyBusinessId) AS MainPlanId FROM PolicyManagement..TPolicyBusiness     
            WHERE PolicyDetailId IN (SELECT PolicyDetailId FROM @PlanList)    
            GROUP BY PolicyDetailId    
     ) AS Topups ON Topups.PolicyDetailId = Pd.PolicyDetailId                            
      JOIN PolicyManagement..TStatusHistory Sh WITH(NOLOCK) On Sh.PolicyBusinessId = Pb.PolicyBusinessId AND CurrentStatusFg = 1                                  
      JOIN PolicyManagement..TStatus Status WITH(NOLOCK) ON Status.StatusId = Sh.StatusId AND Status.IntelligentOfficeStatusType IN ('In Force', 'Paid Up')                                 
      JOIN PolicyManagement..TPlanDescription PDesc WITH(NOLOCK) ON PDesc.PlanDescriptionId = Pd.PlanDescriptionId    
      JOIN PolicyManagement..TRefPlanType2ProdSubType PlanToProd WITH(NOLOCK) ON PlanToProd.RefPlanType2ProdSubTypeId = PDesc.RefPlanType2ProdSubTypeId              
      LEFT JOIN PolicyManagement..TProdSubType Pst WITH(NOLOCK) ON Pst.ProdSubTypeId = PlanToProd.ProdSubTypeId                                  
      JOIN PolicyManagement..TRefPlanType PType WITH(NOLOCK) ON PType.RefPlanTypeId = PlanToProd.RefPlanTypeId                                  
      JOIN PolicyManagement..TRefProdProvider Rpp WITH(NOLOCK) ON Rpp.RefProdProviderId = PDesc.RefProdProviderId   
      JOIN TRefPlanTypeToSection PTS WITH(NOLOCK) ON PTS.RefPlanType2ProdSubTypeId = Pdesc.RefPlanType2ProdSubTypeId                                    
                             
WHERE      
      Pd.IndigoClientId = @IndigoClientId     
      AND PB.IndigoClientId = @IndigoClientId  
      AND Pd.PolicyDetailId IN (SELECT DetailId FROM @PlanList)      
      AND PB.PolicyBusinessId IN (SELECT BusinessId FROM @PlanList)      
      -- check whether to include topups.    
      AND (Topups.MainPlanId = Pb.PolicyBusinessId OR @IncludeTopups = 1)   
      AND PTS.Section = 'Protection'       
      
      
update @income set ProtectionAmount = @TotalProtectionRegularContributions  
  
select   
1 as tag,  
null as parent,  
isnull(RevisedMonthlyIncome,0) as [Income!1!RevisedMonthlyIncome],  
ISNULL(RevisedMonthlyExpenditure,0) as [Income!1!RevisedMonthlyExpenditure],  
isnull(RevisedMonthlyIncome,0) - isnull(RevisedMonthlyExpenditure,0) + ISNULL(ConsolidatedAmount,0) + case when IsProtectionRebroked = 1 then ISNULL(ProtectionAmount,0) else 0 end as [Income!1!RevisedTotalDisposableMonthlyIncome],  
convert(money, (bm1.Tax/100.00)) as [Income!1!IncomeTaxRateClient1],  
convert(money, (bm2.Tax/100.00)) as [Income!1!IncomeTaxRateClient2]  
from @income i  
left join TBudgetMiscellaneous bm1 on bm1.CRMContactId = i.CRMContactId1  
left join TBudgetMiscellaneous bm2 on bm2.CRMContactId = i.CRMContactId2  
  
  
  
FOR XML EXPLICIT  
     
GO
