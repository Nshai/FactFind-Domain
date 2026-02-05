SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
CREATE procedure [dbo].[SpNCustomRetrieveMortgagePlanPurposes]   
@IndigoClientId bigint  
AS    
BEGIN    
DECLARE @RefPlanType2ProdSubType bigint    
    
SELECT @RefPlanType2ProdSubType =  
RefPlanType2ProdSubTypeId   
FROM Policymanagement..TRefPlanType2ProdSubType   
WHERE RefPlanTypeId = (SELECT RefPlanTypeId FROM PolicyManagement..TRefPlanType WHERE PlanTypeName='Mortgage') AND ProdSubTypeId is null  
   
 select    
  1 as Tag ,    
  null as parent,   
      
  A.PlanPurposeId as [MortgagePlanPurposeType!1!PlanPurposeId],     
  A.Descriptor as [MortgagePlanPurposeType!1!PlanPurposeDesc]    
 from policymanagement..TPlanPurpose A    
 inner join policymanagement..TPlanTypePurpose B on B.PlanPurposeId=A.PlanPurposeId    
 where A.IndigoClientId=@IndigoClientId and B.RefPlanType2ProdSubTypeId=@RefPlanType2ProdSubType   and MortgageRelatedfg = 1 
 order by [MortgagePlanPurposeType!1!PlanPurposeId]    
 for xml explicit    
END 
GO
