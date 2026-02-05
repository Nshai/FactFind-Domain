SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveWrapperProviderByRefPlanTypeId]       
 @RefPlanTypeId bigint = 0      
  

AS      
      
  
BEGIN      
 SELECT      
 1 AS Tag,      
 NULL AS Parent,      
 T1.WrapperProviderId AS [WrapperProvider!1!WrapperProviderId],       
 T1.RefPlanTypeId AS [WrapperProvider!1!RefPlanTypeId],       
 T1.RefProdProviderId AS [WrapperProvider!1!RefProdProviderId],       
 T1.WrapAllowOtherProvidersFg AS [WrapperProvider!1!WrapAllowOtherProvidersFg],       
 T1.SippAllowOtherProvidersFg AS [WrapperProvider!1!SippAllowOtherProvidersFg],       
 T1.WrapperOnly AS [WrapperProvider!1!WrapperOnly],       
 T1.ConcurrencyId AS [WrapperProvider!1!ConcurrencyId],      
 T3.CorporateName AS [WrapperProvider!1!CorporateName],    
 null as [WrapperPlanType!2!RefPlanType2ProdSubTypeId]    
 FROM TWrapperProvider T1      
 inner join TRefProdProvider T2 on T2.RefProdProviderId = T1.RefProdProviderId      
 inner join CRM..TCRMContact T3 on T3.CRMContactId = T2.CRMContactId      
 where ((@RefPlanTypeId = 0) OR (@RefPlanTypeId != 0 AND T1.RefPlanTypeId = @RefPlanTypeId))      
    
union    
    
  SELECT      
 2 AS Tag,      
 1 AS Parent,      
 T1.WrapperProviderId AS [WrapperProvider!1!WrapperProviderId],       
 null,       
 null,       
 null,       
 null,       
 null,       
 null,      
 null,    
 T4.RefPlanType2ProdSubTypeId as [WrapperPlanType!2!RefPlanType2ProdSubTypeId]    
 FROM TWrapperProvider T1      
 inner join TRefProdProvider T2 on T2.RefProdProviderId = T1.RefProdProviderId      
 inner join CRM..TCRMContact T3 on T3.CRMContactId = T2.CRMContactId      
 inner join TWrapperPlanType T4 on T4.WrapperProviderId = T1.WrapperProviderId    
 where ((@RefPlanTypeId = 0) OR (@RefPlanTypeId != 0 AND T1.RefPlanTypeId = @RefPlanTypeId))      
    
ORDER BY [WrapperProvider!1!WrapperProviderId]  , [WrapperPlanType!2!RefPlanType2ProdSubTypeId]     
      
  FOR XML EXPLICIT      
      
END      
RETURN (0) 
GO
