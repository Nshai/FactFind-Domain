SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveMultiTieConfig]  
	@IndigoClientId bigint,
	@MultiTieConfigId bigint
AS  

SELECT NULL,
	(-- Get multi-tie config details
	SELECT MultiTieName AS Name
	FROM TMultiTieConfig 
	WHERE MultiTieConfigId = @MultiTieConfigId
	FOR XML RAW ('MultiTieConfig'), TYPE),
	(-- Get providers
	SELECT DISTINCT
		P.RefProdProviderId AS Id,
		ISNULL(PC.CorporateName,'') AS [Name]
	FROM 
		TMultiTieConfig MTC
		JOIN TMultiTie MT ON MT.MultiTieConfigId = MTC.MultiTieConfigId
		JOIN TRefProdProvider P ON P.RefProdProviderId = MT.RefProdProviderId
		JOIN CRM..TCRMContact PC ON PC.CRMContactId = P.CRMContactId  	
	WHERE 
		MT.IndigoClientId = @IndigoClientId  
		AND MT.MultiTieConfigId = @MultiTieConfigId
		AND P.RetireFg = 0
	ORDER BY [Name]
	FOR XML RAW ('Provider'), TYPE),
	(-- Get plan types
	SELECT  
		MT.RefProdProviderId AS ProviderId,		
		T2.PlanTypeName + isnull(' (' + pst.ProdSubTypeName + ')','') AS Name
	FROM 
		TMultiTie MT  
		JOIN TRefPlanType2ProdSubType r ON r.RefPlanType2ProdSubTypeId = MT.RefPlanType2ProdSubTypeId
		JOIN TRefPlanType t2 ON r.RefPlanTypeId = t2.RefPlanTypeId  
		LEFT JOIN TProdSubType pst ON pst.ProdSubTypeId = r.ProdSubTypeId
	WHERE 
		MT.IndigoClientId = @IndigoClientId
		AND MT.MultiTieConfigId = @MultiTieConfigId
	ORDER BY 
		PlanTypeName
	FOR XML RAW ('PlanType'), TYPE)
FOR XML PATH('')
GO
