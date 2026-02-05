SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveSubPlanTypesBySectionAsXml]
	@ProviderName VARCHAR(255),
	@PlanTypeName VARCHAR(255)
AS
BEGIN
SELECT DISTINCT
	PTS.RefPlanType2ProdSubTypeId AS [Id],
	CASE                               
		WHEN LEN(ISNULL(Pst.ProdSubTypeName, '')) > 0 THEN  PType.PlanTypeName + ' (' + Pst.ProdSubTypeName + ')'                              
		ELSE PType.PlanTypeName                              
	END AS [Name]
FROM
	TRefPlanTypeToSection PTS
	JOIN PolicyManagement..TRefPlanType2ProdSubType P2P WITH(NOLOCK) ON P2P.RefPlanType2ProdSubTypeId = PTS.RefPlanType2ProdSubTypeId
	LEFT JOIN PolicyManagement..TProdSubType Pst WITH(NOLOCK) ON Pst.ProdSubTypeId = P2P.ProdSubTypeId                              
	JOIN PolicyManagement..TRefPlanType PType WITH(NOLOCK) ON PType.RefPlanTypeId = P2P.RefPlanTypeId                              
WHERE
	 PTS.RefPlanType2ProdSubTypeId IN 
	(
			SELECT RefPlanType2ProdSubTypeId FROM policymanagement..TWrapperPlanType 
			WHERE WrapperProviderId IN 
				(SELECT WrapperProviderId FROM 	policymanagement..TWrapperProvider Wp
				INNER JOIN policymanagement..TRefProdProvider TR
				ON TR.RefProdProviderId = Wp.RefProdProviderId
				LEFT JOIN policymanagement..TRefPlanType TRP
				ON TRP.RefPlanTypeId = Wp.RefPlanTypeId
				LEFT JOIN PolicyManagement..TRefPlanType2ProdSubType Plan2Prod ON Plan2Prod.RefPlanTypeId = TRP.RefPlanTypeId
				LEFT JOIN PolicyManagement..TProdSubType PST ON PST.ProdSubTypeId = Plan2Prod.ProdSubTypeId
				INNER JOIN CRM..TCRMContact CR
				ON CR.CRMContactId = TR.CRMContactId
				WHERE (TRP.PlanTypeName = @PlanTypeName OR TRP.PlanTypeName + ISNULL(' (' + PST.ProdSubTypeName + ')', '') = @PlanTypeName)
					AND CR.CorporateName = @ProviderName)
	)
ORDER BY
	[Name]
FOR XML RAW ('PlanType')
END
GO
