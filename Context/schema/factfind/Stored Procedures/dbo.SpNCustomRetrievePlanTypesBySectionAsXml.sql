SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrievePlanTypesBySectionAsXml]
	@Section varchar(64),
	@RegionCode varchar(2) = null
AS  
BEGIN
		SELECT  
		 PTS.RefPlanType2ProdSubTypeId AS [id],  
		 CASE                                 
		  WHEN LEN(ISNULL(Pst.ProdSubTypeName, '')) > 0 THEN  PType.PlanTypeName + ' (' + Pst.ProdSubTypeName + ')'                                
		  ELSE PType.PlanTypeName                                
		 END AS [description]  
		FROM  
		 TRefPlanTypeToSection PTS  
		 JOIN PolicyManagement..TRefPlanType2ProdSubType P2P WITH(NOLOCK) ON P2P.RefPlanType2ProdSubTypeId = PTS.RefPlanType2ProdSubTypeId  
		 LEFT JOIN PolicyManagement..TProdSubType Pst WITH(NOLOCK) ON Pst.ProdSubTypeId = P2P.ProdSubTypeId                                
		 JOIN PolicyManagement..TRefPlanType PType WITH(NOLOCK) ON PType.RefPlanTypeId = P2P.RefPlanTypeId                                
		WHERE  
		 PTS.Section = @Section And PType.RetireFg = 0
		 AND (@RegionCode IS NULL OR P2P.RegionCode = @RegionCode)
		ORDER BY  
		 [description]  
		FOR XML RAW ('PlanType')  
END
GO
