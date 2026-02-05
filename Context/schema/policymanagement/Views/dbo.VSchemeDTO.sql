SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE VIEW dbo.VSchemeDTO

AS

SELECT
	GS.GroupSchemeId,
	GS.OwnerCRMContactId,
	ProvCorp.CorporateName AS ProviderName,
	CASE
		WHEN ST.ProdSubTypeId IS NOT NULL THEN PT.PlanTypeName +'('+ST.ProdSubTypeName+')'
		ELSE PT.PlanTypeName
	END AS ProductName,
	GS.SchemeNumber,
	S.IntelligentOfficeStatusType,
	S.Name AS CurrentStatusName
FROM
	dbo.TGroupScheme GS
	JOIN dbo.TPolicyBusiness PB ON PB.PolicyBusinessId = GS.PolicyBusinessId
	JOIN dbo.TStatusHistory SH ON SH.PolicyBusinessId = GS.PolicyBusinessId
		AND SH.CurrentStatusFG = 1
	JOIN dbo.TStatus S ON S.StatusId = SH.StatusId
	JOIN dbo.TPolicyDetail PDet ON PDet.PolicyDetailId = PB.PolicyDetailId
	JOIN dbo.TPlanDescription PDes ON PDes.PlanDescriptionId = PDet.PlanDescriptionId
	JOIN dbo.TRefProdProvider Prov ON Prov.RefProdProviderId = PDes.RefProdProviderId
	JOIN CRM.dbo.TCRMContact ProvC ON ProvC.CRMContactId = Prov.CRMContactId
	JOIN CRM.dbo.TCorporate ProvCorp ON ProvCorp.CorporateId = ProvC.CorporateId
	JOIN dbo.TRefPlanType2ProdSubType R2P ON R2P.RefPlanType2ProdSubTypeId = PDes.RefPlanType2ProdSubTypeId
	JOIN dbo.TRefPlanType PT ON PT.RefPlanTypeId = R2P.RefPlanTypeId
	LEFT JOIN dbo.TProdSubType ST ON ST.ProdSubTypeId = R2P.ProdSubTypeId
	
GO
