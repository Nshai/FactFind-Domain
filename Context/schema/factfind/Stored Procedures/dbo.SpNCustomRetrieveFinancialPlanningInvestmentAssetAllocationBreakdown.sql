SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveFinancialPlanningInvestmentAssetAllocationBreakdown]  
 @InvestmentId Bigint,  
 @InvestmentType varchar(255)  = null
   
AS  
  
  
SELECT T1.FinancialPlanningInvestmentAssetAllocationId, T1.FinancialPlanningId, T1.InvestmentId, T1.InvestmentType, T2.AssetClass, T2.AllocationPercentage  
FROM TFinancialPlanningInvestmentAssetAllocation  T1    
inner join TFinancialPlanningInvestmentAssetAllocationBreakdown T2 on T1.FinancialPlanningInvestmentAssetAllocationId = T2.FinancialPlanningInvestmentAssetAllocationId  
WHERE  
  T1.InvestmentId = @InvestmentId and    
  (T1.InvestmentType = @InvestmentType or @InvestmentType is null) and  
  T1.FinancialPlanningInvestmentAssetAllocationId =   
   (select max(T2.FinancialPlanningInvestmentAssetAllocationId) from TFinancialPlanningInvestmentAssetAllocation t2  
   WHERE T2.InvestmentId = @InvestmentId and  (T2.InvestmentType = @InvestmentType or @InvestmentType is null)  )
   
   
GO
