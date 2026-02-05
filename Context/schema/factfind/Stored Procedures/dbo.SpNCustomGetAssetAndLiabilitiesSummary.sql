USE [factfind]
 
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomGetAssetAndLiabilitiesSummary]	
  @PartyId BIGINT,                           
  @RelatedPartyId BIGINT,                       
  @TenantId bigint,
  @CurrentUserDate datetime
AS

DECLARE @Client1AssetValue Money, @Client2AssetValue Money, @JointAssetValue Money
DECLARE @Client1TotalNetMonthlyIncome Money, @Client2TotalNetMonthlyIncome Money, @JointTotalNetMonthlyIncome Money
DECLARE @Client1LiabilityValue Money, @Client2LiabilityValue Money, @JointLiabilityValue Money

DECLARE @AssetIdsString varchar(max);
--concatenate Ids into string separated by comma
SELECT @AssetIdsString = COALESCE(@AssetIdsString + ', ' + CAST(AssetsId as varchar(20)), CAST(AssetsId as varchar(20))) 
FROM 
(
	--client 1 assets
	SELECT asset.AssetsId
	FROM dbo.TAssets asset
		INNER JOIN crm.dbo.tcrmcontact owner1
			ON asset.crmcontactid = owner1.crmcontactid 
		WHERE owner1.crmcontactid = @PartyId AND ISNULL(asset.crmcontactid2, 0) = 0 -- client 1 assets condition
			AND owner1.IndClientId = @TenantId
	UNION
	--client 2 assets
	SELECT asset.AssetsId
	FROM  dbo.tassets asset
		INNER JOIN crm.dbo.tcrmcontact owner1
			ON asset.crmcontactid = owner1.crmcontactid 
		WHERE @RelatedPartyId> 0 
			AND owner1.crmcontactid = @RelatedPartyId AND ISNULL(asset.crmcontactid2, 0) = 0 --client 2 assets condition
			AND owner1.IndClientId = @TenantId
	UNION
	--joint assets
	SELECT asset.AssetsId
	FROM dbo.tassets asset
			INNER JOIN crm.dbo.tcrmcontact owner1
			ON asset.crmcontactid = owner1.crmcontactid 
		WHERE @RelatedPartyId> 0 
			AND owner1.crmcontactid = @PartyId AND asset.crmcontactid2 = @RelatedPartyId -- joint assets condition
			AND owner1.IndClientId = @TenantId
) assetIds

DECLARE @AssetIds TABLE(AssetId bigint);
INSERT INTO @AssetIds 
	SELECT Id FROM dbo.FnGetIdsFromString(@AssetIdsString, ',')

DECLARE @AssetCurrentValues TABLE (CRMContactId INT, CRMContactId2 INT, Valuation MONEY, NetMonthlyIncome MONEY)
INSERT INTO @AssetCurrentValues
SELECT asset.CRMContactId, asset.CRMContactId2, assetValue.Valuation, 
CASE
	WHEN asset.IncomeId IS NOT NULL THEN factfind.dbo.FnCustomGetMonthlyIncomeNetAmount(incomes.NetAmount, incomes.Frequency)
	ELSE 0
END as NetMonthlyIncome
FROM dbo.tassets asset
INNER JOIN @AssetIds filteredAssets
	ON filteredAssets.AssetId = asset.AssetsId
LEFT JOIN [FnRetrieveAssetCurrentValues] (@AssetIdsString) assetValue 
	ON assetValue.AssetId = asset.AssetsId
LEFT JOIN factfind..TDetailedincomebreakdown incomes 
	on asset.IncomeId = incomes.DetailedincomebreakdownId
WHERE incomes.EndDate is null or incomes.EndDate > @CurrentUserDate;

SELECT @Client1AssetValue = Sum(Valuation)
	FROM @AssetCurrentValues
	WHERE crmcontactid = @PartyId AND ISNULL(crmcontactid2, 0) = 0; -- client 1 assets condition

SELECT @Client1TotalNetMonthlyIncome = Sum(NetMonthlyIncome)
	FROM @AssetCurrentValues
	WHERE crmcontactid = @PartyId AND ISNULL(crmcontactid2, 0) = 0; -- client 1 assets condition

SELECT @Client1LiabilityValue = Sum(liabilities.amount)
                 FROM   dbo.tliabilities liabilities
                        INNER JOIN crm.dbo.tcrmcontact owner1
                        ON liabilities.crmcontactid = owner1.crmcontactid   
                 WHERE  owner1.crmcontactid = @PartyId  AND ISNULL(liabilities.crmcontactid2, 0)= 0 AND owner1.IndClientId = @TenantId

IF(@RelatedPartyId> 0)
BEGIN
	SELECT  @Client2AssetValue = Sum(Valuation) 
		FROM @AssetCurrentValues
		WHERE crmcontactid = @RelatedPartyId AND ISNULL(crmcontactid2, 0) = 0; -- client 1 assets condition

	SELECT  @Client2TotalNetMonthlyIncome = Sum(NetMonthlyIncome) 
		FROM @AssetCurrentValues
		WHERE crmcontactid = @RelatedPartyId AND ISNULL(crmcontactid2, 0) = 0; -- client 2 assets condition

	SELECT  @JointAssetValue = Sum(Valuation) 
		FROM @AssetCurrentValues
		WHERE crmcontactid = @PartyId AND crmcontactid2 = @RelatedPartyId; -- joint assets condition

	SELECT  @JointTotalNetMonthlyIncome = Sum(NetMonthlyIncome) 
		FROM @AssetCurrentValues
		WHERE crmcontactid = @PartyId AND crmcontactid2 = @RelatedPartyId; -- joint assets condition

	SELECT @Client2LiabilityValue = Sum(liabilities.amount)
    FROM   dbo.tliabilities liabilities
			INNER JOIN crm.dbo.tcrmcontact owner1
			ON liabilities.crmcontactid = owner1.crmcontactid   
    WHERE  owner1.crmcontactid = @RelatedPartyId  AND ISNULL(liabilities.crmcontactid2, 0)= 0 AND owner1.IndClientId = @TenantId

	SELECT @JointLiabilityValue = Sum(liabilities.amount)
	FROM   dbo.tliabilities liabilities
			INNER JOIN crm.dbo.tcrmcontact owner1
			ON liabilities.crmcontactid = owner1.crmcontactid   
	WHERE  owner1.crmcontactid = @PartyId  AND liabilities.crmcontactid2= @RelatedPartyId AND owner1.IndClientId = @TenantId
END
SELECT DISTINCT this.budgetmiscellaneousid						AS Id,
                 ISNULL(this.assetsnondisclosure, 0)			AS AssetsNonDisclosure,
                 ISNULL(this.liabilitiesnondisclosure, 0)		AS LiabilitiesNonDisclosure,
                 this.assetliabilitynotes						AS AssetLiabilityNotes,
                 @Client1AssetValue								AS Client1AssetValue,
                 @Client2AssetValue								AS Client2AssetValue,
                 @JointAssetValue								AS JointAssetValue,
                 @Client1TotalNetMonthlyIncome					AS Client1TotalNetMonthlyIncome,
                 @Client2TotalNetMonthlyIncome					AS Client2TotalNetMonthlyIncome,
                 @JointTotalNetMonthlyIncome					AS JointTotalNetMonthlyIncome,
				 @Client1LiabilityValue							AS Client1LiabilityValue,
                 @Client2LiabilityValue							AS Client2LiabilityValue,
				 @JointLiabilityValue							AS JointLiabilityValue,
				 this.AnyAssets									AS HasAssets,
				 this.AnyLiabilities							AS HasLiabilities,
				 this.LiabilitiesRepayment						AS WishToConsiderRepaymentOrReduction,
				 this.LiabilitiesWhyNot							AS ReasonForNotConsideringRepaymentOrReduction,
				 this.LiabilityNotes							AS ReasonForNotConsideringRepaymentOrReductionNotes
FROM   dbo.tbudgetmiscellaneous this
       INNER JOIN crm.dbo.tcrmcontact party1 ON this.crmcontactid = party1.crmcontactid 
WHERE  party1.crmcontactid = @PartyId and party1.IndClientId = @TenantId  

