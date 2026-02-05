SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomInvuPlan]
	@Id bigint
AS
SELECT
	ISNULL(C.CorporateName, C.FirstName + ' ' + C.LastName) AS Client_Name,
	ISNULL(C.ExternalReference, '') AS Client_Primary_Ref,
	ISNULL(C.AdditionalRef, '') AS Secondary_Ref,
	ISNULL(C.MigrationRef, '') AS Migration_Ref,
	ISNULL(C.CurrentAdviserName, '') AS Servicing_Adviser,
	Pb.SequentialRef AS Plan_IOB,
	RppC.CorporateName AS Provider,
	PTy.PlanTypeName AS Plan_Type,
	ISNULL(Pb.PolicyNumber, '') AS Plan_Number,
	ISNULL(Pb.ProductName, '') AS Product_Name,
	ISNULL(Pbe.MigrationRef, '') AS Policy_Migration_Ref
FROM		
	PolicyManagement..TPolicyBusiness Pb WITH(NOLOCK)
	LEFT JOIN PolicyManagement..TPolicyBusinessExt Pbe WITH(NOLOCK) ON Pbe.PolicyBusinessId = Pb.PolicyBusinessId
	JOIN PolicyManagement..TPolicyDetail Pd WITH(NOLOCK) ON Pd.PolicyDetailId = Pb.PolicyDetailId
	JOIN PolicyManagement..TPlanDescription PlanD WITH(NOLOCK) ON PlanD.PlanDescriptionId = Pd.PlanDescriptionId
	JOIN PolicyManagement..TRefPlanType2ProdSubType Plan2Prod WITH(NOLOCK) ON Plan2Prod.RefPlanType2ProdSubTypeId = PlanD.RefPlanType2ProdSubTypeId
	LEFT JOIN PolicyManagement..TProdSubType pst ON pst.ProdSubTypeId = Plan2Prod.ProdSubTypeId
	JOIN PolicyManagement..TRefPlanType PTy WITH(NOLOCK) ON PTy.RefPlanTypeId = Plan2Prod.RefPlanTypeId
	JOIN PolicyManagement..TRefProdProvider Rpp WITH(NOLOCK) ON Rpp.RefProdProviderId = PlanD.RefProdProviderId
	JOIN CRM..TCRMContact RppC WITH(NOLOCK) ON RppC.CRMContactId = Rpp.CRMContactId		
	JOIN (
		SELECT
			PolicyBusinessId,
			MIN(PolicyOwnerId) AS PolicyOwnerId
		FROM 
			PolicyManagement..TPolicyOwner PO WITH(NOLOCK)
			JOIN PolicyManagement..TPolicyBusiness PB WITH(NOLOCK) ON PB.PolicyDetailId = PO.PolicyDetailId
		WHERE
			PB.PolicyBusinessId = @Id
		GROUP BY
			PB.PolicyBusinessId) AS MinPO ON MinPO.PolicyBusinessId = PB.PolicyBusinessId
	JOIN PolicyManagement..TPolicyOwner PO WITH(NOLOCK) ON PO.PolicyOwnerId = MinPO.PolicyOwnerId
	JOIN CRM..TCRMContact C WITH(NOLOCK) ON C.CRMContactId = PO.CRMContactId
WHERE
	Pb.PolicyBusinessId = @Id
FOR XML RAW
GO
