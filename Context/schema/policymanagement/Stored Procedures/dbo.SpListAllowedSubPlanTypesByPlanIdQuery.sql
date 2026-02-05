SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spListAllowedSubPlanTypesByPlanIdQuery]
	@RefPlanType2ProdSubType bigint,
	@ProviderId bigint, 
	@RegionCode VARCHAR(5)
AS
BEGIN

SELECT DISTINCT
	refplantyp3_.RefPlanType2ProdSubTypeId AS [Id],
	CASE                               
		WHEN LEN(ISNULL(productsub5_.ProdSubTypeName, '')) > 0 THEN  refplantyp4_.PlanTypeName + ' (' + productsub5_.ProdSubTypeName + ')'                              
		ELSE refplantyp4_.PlanTypeName                              
	END AS [Name]
FROM TWrapperProvider WP 
INNER JOIN TRefPlanType2ProdSubType rpt2pst on rpt2pst.RefPlanTypeId = WP.RefPlanTypeId
INNER JOIN TWrapperPlanType wrapperpla2_ on WP.WrapperProviderId=wrapperpla2_.WrapperProviderId  
INNER JOIN TRefPlanType2ProdSubType refplantyp3_ on wrapperpla2_.RefPlanType2ProdSubTypeId=refplantyp3_.RefPlanType2ProdSubTypeId  
INNER JOIN TRefPlanType refplantyp4_ on refplantyp3_.RefPlanTypeId=refplantyp4_.RefPlanTypeId 
LEFT OUTER JOIN TProdSubType productsub5_ on refplantyp3_.ProdSubTypeId=productsub5_.ProdSubTypeId 
	WHERE WP.RefProdProviderId = @ProviderId 
	and rpt2pst.RefPlanType2ProdSubTypeId = @RefPlanType2ProdSubType 
	and refplantyp3_.IsArchived = 0 
	and refplantyp3_.RegionCode = @RegionCode
ORDER BY
	[Name]
END
GO
