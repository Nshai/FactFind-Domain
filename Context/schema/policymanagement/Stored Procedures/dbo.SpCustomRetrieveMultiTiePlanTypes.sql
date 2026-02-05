SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[SpCustomRetrieveMultiTiePlanTypes]    
 @IndigoClientId bigint,    
 @PractitionerId bigint,    
 @ProviderId bigint ,   
 @IsWrapperProvider bit = 0    
AS    
BEGIN    
    
 SELECT  DISTINCT  
  1 AS Tag,    
  NULL AS Parent,    
  T3.RefPlanTypeId AS [RefPlanType!1!RefPlanTypeId],   
  T3.IsWrapperFg as [RefPlanType!1!IsWrapperFg],   
  T3.ConcurrencyId AS [RefPlanType!1!ConcurrencyId],    
  T3.PlanTypeName AS [RefPlanType!1!PlanTypeName] ,    
  T4.RefPlanType2ProdSubTypeId AS [RefPlanType!1!RefPlanType2ProdSubTypeId],    
  T5.ProdSubTypeName AS [RefPlanType!1!ProdSubTypeName],    
  Case    
   When (T5.ProdSubTypeName) Is Not Null   
   Then  T3.PlanTypeName + '  (' + ISNULL(T5.ProdSubTypeName, '')  + ')'    
   Else  T3.PlanTypeName     
  End As  [RefPlanType!1!DisplayName] ,  
  
  NULL as [WrapperPlanType!2!RefPlanType2ProdSubTypeId] ,  
  NULL as [WrapperPlanType!2!WrapperProviderId] ,  
  NULL as [WrapperPlanType!2!RefProdProviderId] ,  
  NULL as [WrapperPlanType!2!WrapperRefPlanTypeId]   
   
 From TRefPlanType T3    
 INNER JOIN TRefPlanType2ProdSubType T4 on T4.RefPlanTypeId = T3.RefPlanTypeId    
 LEFT JOIN TProdSubType T5 on T5.ProdSubTypeId = T4.ProdSubTypeId    
 INNER JOIN Compliance..TGating T6 on T6.RefPlanType2ProdSubTypeId = T4.RefPlanType2ProdSubTypeId    
 INNER JOIN TMultiTie T7 ON T7.RefPlanType2ProdSubTypeId = T4.RefPlanType2ProdSubTypeId    
 LEFT JOIN TWrapperPlanType T8 ON T4.RefPlanType2ProdSubTypeId = T8.RefPlanType2ProdSubTypeId --and WrapperProviderId = @ProviderId  
 LEFT JOIN TWrapperProvider T9 ON T8.wrapperProviderId= T9.WrapperProviderId   
 LEFT JOIN TWrapperProvider T10 ON T10.RefPlanTypeId = T3.RefPlanTypeId  
 Where T3.RetireFg = 0    
 AND (T3.SchemeType=0 OR T3.SchemeType=1)     
 AND T6.PractitionerId = @PractitionerId    
 AND T7.IndigoClientId = @IndigoClientId    
 AND T7.RefProdProviderId = @ProviderId    
 AND   
 (  
        -- if wrapper provider then return the wrap and it's linked plans for the provider only  
  (@IsWrapperProvider = 0 /*AND T10.WrapperProviderId IS NULL*/) -- SREE copied from SpCustomListPlanTypesAndSubTypesForIndividualWithGating  
  OR   
  (  
   (  
    @IsWrapperProvider = 1 AND T8.WrapperPlanTypeId IS NOT NULL AND T3.IsWrapperFg = 0  
   )   
   AND   
   (  
    (@ProviderId = 0 ) OR (@ProviderId > 0 AND ISNULL(T9.RefProdProviderId, 0) = @ProviderId)  
   )    
  )    
  OR   
  (  
   (  
    @IsWrapperProvider = 1 AND T8.WrapperPlanTypeId IS NULL     AND T3.IsWrapperFg = 1  
   )   
   AND   
   (  
    (@ProviderId = 0 ) OR (@ProviderId > 0 AND ISNULL(T10.RefProdProviderId, 0) = @ProviderId)  
   )  
  )  
  )  
Order By [RefPlanType!1!PlanTypeName],  [RefPlanType!1!ProdSubTypeName]    
    
FOR XML EXPLICIT    
    
END  
  
  
  
  
GO
