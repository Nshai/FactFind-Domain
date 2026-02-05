SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*****************************************************
** Description:	
** Gets all assets for a client, filtered by IsDeleted, IsVisibleToClient, includes relatives as well.
**
** History:
** 2016-06-10	R PITOUT	Created
** 2016-06-27	R PITOUT	Updated to include additional fields.
**                          This will be used by portfolio in the asset and asset valuation related endpoints.
******************************************************/
CREATE PROCEDURE [dbo].[nio_PS_GetAllAssetsForClient]
	@CrmContactId INT,
	@TenantId INT,
	@IgnoreVisibilitySettings bit,
	@GetFamilyGroupMembersAssets bit = 0
AS

	CREATE TABLE #ClientIds(CrmContactId INT)
	INSERT INTO	#ClientIds SELECT @CrmContactId

	 -- add relationship contact Ids
	IF (@GetFamilyGroupMembersAssets = 0)
	BEGIN
	INSERT INTO	
		#ClientIds
	SELECT r.CRMContactToId
	FROM crm..TRelationship r
		WHERE r.CRMContactFromId = @CrmContactId and (r.IncludeInPfp=1 or @IgnoreVisibilitySettings = 1)
	END
    -- add family group members contact Ids
	ELSE
	BEGIN 
	  INSERT INTO #ClientIds (CrmContactId)
	  SELECT CrmContactID FROM [crm]..FnRetrieveFamilyGroupByCRMContactId(@CrmContactId, @TenantId) FG
	END
	
	CREATE CLUSTERED INDEX IDX_C2_Relatives_CrmContactId ON #ClientIds(CrmContactId)

	SELECT DISTINCT
		A.AssetsId AS Id,
		C1.CRMContactId AS Owner1Id,
		C1.FirstName AS Owner1FirstName,
		C1.FirstName + ' ' + C1.LastName AS Owner1FullName,
		C2.CRMContactId AS Owner2Id,
		C2.FirstName AS Owner2FirstName,
		C2.FirstName + ' ' + C2.LastName AS Owner2FullName,
		A.[Owner] as OwnerType,
		OwnerFilter = CASE WHEN A.[Owner] = 'Client 1' AND C1.CRMContactId = @CrmContactId THEN 'Primary' ELSE
			CASE WHEN A.[Owner] = 'Client 1' AND C1.CRMContactId <> @CrmContactId Then 'Partner' ELSE
			CASE WHEN A.[Owner] = 'Joint' THEN 'Joint' END END END,
		AC.CategoryName AS Category,
		AC.SectorName AS IMASector,
		[Description],
		A.PurchasedOn AS PurchaseDate,
		A.PurchasePrice AS OriginalValue,
		A.Amount As Value,
		A.ValuedOn AS ValueDate,
		A.Amount - A.PurchasePrice AS ProfitLoss,
		Isnull((A.Amount - A.PurchasePrice) / nullif(A.PurchasePrice,0),0) AS ProfitLossPercent,
		A.PolicyBusinessId AS RelatedPlanId,
		A.WhoCreatedUserId AS WhoCreatedUserId,
		A.IsVisibleToClient
	FROM 
		factfind..TAssets A 
		LEFT OUTER JOIN crm..TCRMContact C1 ON C1.CRMContactId = A.CRMContactId AND C1.IndClientId = @TenantId 
		LEFT OUTER JOIN crm..TCRMContact C2 ON C2.CRMContactId = A.CRMContactId2 AND C2.IndClientId = @TenantId 
		INNER JOIN #ClientIds CL on A.CRMContactId = CL.CrmContactId
		LEFT JOIN factfind..TAssetCategory AC on A.AssetCategoryId = AC.AssetCategoryId
		LEFT JOIN policymanagement..TPolicyBusiness VPB on VPB.PolicyBusinessId = A.PolicyBusinessId
		LEFT JOIN PolicyManagement.dbo.[TPolicyDetail] pdetail on vpb.PolicyDetailId = pdetail.PolicyDetailId
        LEFT JOIN PolicyManagement.dbo.[VPlanDescription] pdesc on pdetail.PlanDescriptionId = pdesc.PlanDescriptionId
        LEFT JOIN PolicyManagement.dbo.TRefPlanType2ProdSubType refplantype on pdesc.RefPlanType2ProdSubTypeId = refplantype.RefPlanType2ProdSubTypeId
	WHERE 
		(A.IsVisibleToClient = 1 or @IgnoreVisibilitySettings = 1)
		AND 
		(ISNULL(A.PolicyBusinessId, 0) = 0 or (refplantype.RefPlanType2ProdSubTypeId in (67,68,151,152,153,154,1007,1008,1081,1082,1083,1085,1086,1087,1088,1089,1090,1091,1092,1093,1095))) 

	UNION

	SELECT DISTINCT
		A.AssetsId AS Id,
		C1.CRMContactId AS Owner1Id,
		C1.FirstName AS Owner1FirstName,
		C1.FirstName + ' ' + C1.LastName AS Owner1FullName,
		C2.CRMContactId AS Owner2Id,
		C2.FirstName AS Owner2FirstName,
		C2.FirstName + ' ' + C2.LastName AS Owner2FullName,
		A.[Owner] as OwnerType,
		OwnerFilter = CASE WHEN A.[Owner] = 'Client 1' AND C1.CRMContactId = @CrmContactId THEN 'Primary' ELSE
			CASE WHEN A.[Owner] = 'Client 1' AND C1.CRMContactId <> @CrmContactId Then 'Partner' ELSE
			CASE WHEN A.[Owner] = 'Joint' THEN 'Joint' END END END,
		AC.CategoryName AS Category,
		AC.SectorName AS IMASector,
		[Description],
		A.PurchasedOn AS PurchaseDate,
		A.PurchasePrice AS OriginalValue,
		A.Amount As Value,
		A.ValuedOn AS ValueDate,
		A.Amount - A.PurchasePrice AS ProfitLoss,
		Isnull((A.Amount - A.PurchasePrice) / nullif(A.PurchasePrice,0),0) AS ProfitLossPercent,
		A.PolicyBusinessId AS RelatedPlanId,
		A.WhoCreatedUserId AS WhoCreatedUserId,
		A.IsVisibleToClient
	FROM 
		factfind..TAssets A 
		LEFT OUTER JOIN crm..TCRMContact C1 ON C1.CRMContactId = A.CRMContactId AND C1.IndClientId = @TenantId 
		LEFT OUTER JOIN crm..TCRMContact C2 ON C2.CRMContactId = A.CRMContactId2 AND C2.IndClientId = @TenantId 
		INNER JOIN #ClientIds CL on A.CRMContactId2 = CL.CrmContactId
		LEFT JOIN factfind..TAssetCategory AC on A.AssetCategoryId = AC.AssetCategoryId
		LEFT JOIN policymanagement..TPolicyBusiness VPB on VPB.PolicyBusinessId = A.PolicyBusinessId
		LEFT JOIN PolicyManagement.dbo.[TPolicyDetail] pdetail on vpb.PolicyDetailId = pdetail.PolicyDetailId
        LEFT JOIN PolicyManagement.dbo.[VPlanDescription] pdesc on pdetail.PlanDescriptionId = pdesc.PlanDescriptionId
        LEFT JOIN PolicyManagement.dbo.TRefPlanType2ProdSubType refplantype on pdesc.RefPlanType2ProdSubTypeId = refplantype.RefPlanType2ProdSubTypeId
	WHERE 
		(A.IsVisibleToClient = 1 or @IgnoreVisibilitySettings = 1)
		AND 
		(ISNULL(A.PolicyBusinessId, 0) = 0 or (refplantype.RefPlanType2ProdSubTypeId in (67,68,151,152,153,154,1007,1008,1081,1082,1083,1085,1086,1087,1088,1089,1090,1091,1092,1093,1095))) 		


	IF OBJECT_ID('tempdb.dbo.#ClientIds') IS NOT NULL
	DROP TABLE #ClientIds
GO
