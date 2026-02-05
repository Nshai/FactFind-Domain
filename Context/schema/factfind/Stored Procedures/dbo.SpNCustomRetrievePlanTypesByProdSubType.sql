SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrievePlanTypesByProdSubType]  
 @ProdSubType varchar(512) =null,
 @ProdSubTypeSecond varchar(512) =null,
 @RegionCode varchar(2) = 'GB' 
AS  
IF(ISNULL(@ProdSubType,'') = '') 
BEGIN  
SELECT    
 P2P.RefPlanType2ProdSubTypeId AS [Id],    
 CASE                                   
  WHEN LEN(ISNULL(Pst.ProdSubTypeName, '')) > 0 THEN  PType.PlanTypeName + ' (' + Pst.ProdSubTypeName + ')'                                  
  ELSE PType.PlanTypeName                                  
 END AS [Name]    
FROM  PolicyManagement..TRefPlanType2ProdSubType P2P WITH(NOLOCK)   
 LEFT JOIN PolicyManagement..TProdSubType Pst WITH(NOLOCK) ON Pst.ProdSubTypeId = P2P.ProdSubTypeId                                  
 JOIN PolicyManagement..TRefPlanType PType WITH(NOLOCK) ON PType.RefPlanTypeId = P2P.RefPlanTypeId                                  
WHERE    
 Pst.ProdSubTypeName in ('Building', 'Contents','Building & Contents','Let Property')
 AND P2P.[RegionCode] = @RegionCode 
ORDER BY    
 [Name]  
FOR XML RAW ('PlanType') 
 END
 ELSE
BEGIN 
 SELECT    
 P2P.RefPlanType2ProdSubTypeId AS [Id],    
 CASE                                   
  WHEN LEN(ISNULL(Pst.ProdSubTypeName, '')) > 0 THEN  PType.PlanTypeName + ' (' + Pst.ProdSubTypeName + ')'                                  
  ELSE PType.PlanTypeName                                  
 END AS [Name]    
FROM  PolicyManagement..TRefPlanType2ProdSubType P2P WITH(NOLOCK)   
 LEFT JOIN PolicyManagement..TProdSubType Pst WITH(NOLOCK) ON Pst.ProdSubTypeId = P2P.ProdSubTypeId                                  
 JOIN PolicyManagement..TRefPlanType PType WITH(NOLOCK) ON PType.RefPlanTypeId = P2P.RefPlanTypeId                                  
WHERE    
 Pst.ProdSubTypeName in (@ProdSubType, @ProdSubTypeSecond)
 AND P2P.[RegionCode] = @RegionCode  
ORDER BY    
 [Name]  
FOR XML RAW ('PlanType') 
 END
