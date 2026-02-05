SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.nio_SpCustomListPlansForClientSummary
	@OwnerClientPartyId BIGINT,
	@LoggedInUser BIGINT,
	@TenantId BIGINT
AS


--DECLARE @OwnerClientPartyId BIGINT, @TenantId BIGINT
--SELECT @OwnerClientPartyId = 961980, @TenantId = 99

-- Entity Security processing for Provider Link to Accounts
-- SuperUser and SuperViewer processing 
-- (Need to do this because NIO does not pass the @TenantId as a negated value for SuperUsers and SuperViewers
-- A negative Id results in Entity Security being overridden
IF(@LoggedInUser > 0) BEGIN
	IF EXISTS (SELECT 1 FROM Administration..TUser WHERE UserId = @LoggedInUser AND (SuperUser = 1 OR SuperViewer = 1)) 
		SET @LoggedInUser = @LoggedInUser * -1
END

-- User rights    
DECLARE @RightMask int, @AdvancedMask int    
SELECT @RightMask = 1, @AdvancedMask = 0
-- SuperViewers won't have an entry in the key table so we need to get their rights now    
IF @LoggedInUser < 0    
 EXEC Administration..SpCustomGetSuperUserRights @LoggedInUser, 'CRMContact', @RightMask OUTPUT, @AdvancedMask OUTPUT

SELECT
	PB.PolicyBusinessId,
	PB.IndigoClientId AS TenantId,
	CP.FirstName AS OwnerFirstName,
	CP.LastName AS OwnerLastName,
	ProdC.CorporateName AS ProviderName,
	Prod.RefProdProviderId AS ProviderId,
	RPT.PlanTypeName,
	PST.ProdSubTypeName AS ProductSubTypeName,
	PB.PolicyNumber,
	S.Name AS CurrentStatus,
	CASE WHEN PoliciesWithTopUps.PolicyDetailId IS NOT NULL THEN 1 ELSE 0 END AS HasTopUps,
	CASE 
		-- If the Account record for the Provider has been archived return 0 (Don't show Link to Provider Account)
		WHEN ISNULL(ProvACC.ArchiveFg, 1) = 1 THEN 0 
		-- If the Logged In User is the owner of the Account, show the Link.
		WHEN ProvACC._OwnerId = ABS(@LoggedInUser) THEN ProvACC.CRMContactId
		-- If the RightMask bit is anything higher than 1 (Read), show the Link
		WHEN ISNULL(TCKey.RightMask,@RightMask)|ISNULL(TEKey.RightMask, @RightMask) > 1 THEN ProvACC.CRMContactId
		-- Otherwise, don't show the Link
		ELSE 0 
	END AS ProviderAccountPartyId,
	PB.PolicyStartDate AS PolicyStartDate
FROM
	PolicyManagement..TPolicyBusiness PB
	JOIN PolicyManagement..TPolicyDetail PDet ON PDet.PolicyDetailId = PB.PolicyDetailId
	JOIN PolicyManagement..TPolicyOwner PO ON PO.PolicyDetailId = PB.PolicyDetailId
	JOIN CRM..TCRMContact CO ON CO.CRMContactId = PO.CRMContactId
	JOIN CRM..TPerson CP ON CP.PersonId = CO.PersonId
	JOIN PolicyManagement..TPlanDescription PDes ON PDes.PlanDescriptionId = PDet.PlanDescriptionId
	JOIN PolicyManagement..TRefProdProvider Prod ON Prod.RefProdProviderId = PDes.RefProdProviderId
	JOIN CRM..TCRMContact ProdC ON ProdC.CRMContactId = Prod.CRMContactId
	LEFT JOIN CRM..TAccount ProvAC ON ProvAC.RefProductProviderId = Prod.RefProdProviderId
		AND ProvAC.IndigoClientId = @TenantId
	LEFT JOIN CRM..TCRMContact ProvACC ON ProvACC.CRMContactId = ProvAC.CRMContactId
	LEFT JOIN CRM..VwCRMContactKeyByCreatorId AS TCKey ON TCKey.UserId = @LoggedInUser AND TCKey.CreatorId = ProvACC._OwnerId    
	LEFT JOIN CRM..VwCRMContactKeyByEntityId AS TEKey ON TEKey.UserId = @LoggedInUser AND TEKey.EntityId = ProvACC.CRMContactId 	
	JOIN PolicyManagement..TRefPlanType2ProdSubType R2P ON R2P.RefPlanType2ProdSubTypeId = PDes.RefPlanType2ProdSubTypeId
	JOIN PolicyManagement..TRefPlanType RPT ON RPT.RefPlanTypeId = R2P.RefPlanTypeId
	LEFT JOIN PolicyManagement..TProdSubType PST ON PST.ProdSubTypeId = R2P.ProdSubTypeId
	JOIN PolicyManagement..TStatusHistory SH ON SH.PolicyBusinessId = PB.PolicyBusinessId 
	AND SH.CurrentStatusFG = 1
	JOIN PolicyManagement..TStatus S ON S.StatusId = SH.StatusId
	LEFT JOIN 
		(
		SELECT
			PDet1.PolicyDetailId,
			Min(PB1.PolicyBusinessId) AS MainPolicyBusinessId,
			Max(PB1.PolicyBusinessId) AS LastTopUpPolicyBusinessId
		FROM
			PolicyManagement..TPolicyOwner PO1
			JOIN PolicyManagement..TPolicyDetail PDet1 ON PDet1.PolicyDetailId = PO1.PolicyDetailId
			JOIN PolicyManagement..TPolicyBusiness PB1 ON PB1.PolicyDetailId = Pdet1.PolicyDetailId
			JOIN PolicyManagement..TStatusHistory SH ON SH.PolicyBusinessId = PB1.PolicyBusinessId AND SH.CurrentStatusFG = 1
			JOIN PolicyManagement..TStatus S ON S.StatusId = SH.StatusId
		WHERE
			PO1.CRMContactId = @OwnerClientPartyId
			AND PB1.IndigoClientId = @TenantId
			AND S.IntelligentOfficeStatusType != 'Deleted' 
		GROUP BY
			PDet1.PolicyDetailId
		HAVING
			Min(PB1.PolicyBusinessId) != Max(PB1.PolicyBusinessId)
		) PoliciesWithTopUps ON PoliciesWithTopUps.PolicyDetailId = PB.PolicyDetailId
WHERE
	PO.CRMContactId = @OwnerClientPartyId
	AND PB.IndigoClientId = @TenantId
	AND S.IntelligentOfficeStatusType != 'Deleted' 
	--AND R2P.IsArchived = 0
	AND 
		(
			PoliciesWithTopUps.PolicyDetailId IS NULL -- Include All Plans that are not TopUps
			OR 
			PB.PolicyBusinessId = PoliciesWithTopUps.MainPolicyBusinessId -- Include Only the main Plan for a topup chain.
		 )

GO
