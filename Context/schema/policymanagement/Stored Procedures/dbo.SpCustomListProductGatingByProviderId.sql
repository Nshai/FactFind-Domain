SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomListProductGatingByProviderId] @RefProdProviderId bigint  
AS  
  
Select  
    1 AS Tag,  
    NULL AS Parent,  
    T1.ValGatingId AS [ValGating!1!ValGatingId],  
    T1.RefProdProviderId AS [ValGating!1!RefProdProviderId],  
    T3.CorporateName AS [ValGating!1!ProviderName],  
    T1.RefPlanTypeId AS [ValGating!1!RefPlanTypeId],  
    T4.PlanTypeName + ISNULL(T6.ProdSubTypeName, '') AS [ValGating!1!PlanTypeName],  
    IsNull(T1.ProdSubTypeId,0) As [ValGating!1!ProdSubTypeId],  
    ISNULL(T6.ProdSubTypeName, '') As [ValGating!1!ProdSubTypeName],  
    T1.OrigoProductType AS [ValGating!1!OrigoProductType],  
    T1.OrigoProductVersion AS [ValGating!1!OrigoProductVersion],  
    T1.ValuationXSLId As [ValGating!1!ValuationXSLId],  
    IsNull(T7.Description,'') As [ValGating!1!Description],  
    T1.ConcurrencyId AS [ValGating!1!ConcurrencyId]  
  
From PolicyManagement.dbo.TValGating T1  
  
Inner Join PolicyManagement.dbo.TRefProdProvider T2  
On T1.RefProdProviderId = T2.RefProdProviderId  
  
Inner Join CRM.dbo.TCRMContact T3  
On T2.CRMContactId = T3.CRMContactId  
  
Inner Join PolicyManagement.dbo.TRefPlanType T4  
On T1.RefPlanTypeId = T4.RefPlanTypeId  
  
Left JOIN PolicyManagement.dbo.TProdSubType T6 on T6.ProdSubTypeId = T1.ProdSubTypeId  
  
Left JOIN PolicyManagement.dbo.TValuationXSL T7 on T7.ValuationXSLId = T1.ValuationXSLId  
  
Where T1.RefProdProviderId = @RefProdProviderId  
  
ORDER BY [ValGating!1!PlanTypeName], [ValGating!1!ValGatingId]  
  
FOR XML EXPLICIT  
  

GO
