SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- ==============================================================================
-- Description: The function checks if the address is used by any entity
-- ==============================================================================
CREATE FUNCTION [dbo].[FnIsAddressLinkedToOtherEntities]
	(@AddressId bigint,
	 @AssetsId bigint = 0,
	 @MortgageId bigint = 0,
	 @EquityReleaseId bigint = 0)
	RETURNS bit
	
AS
BEGIN
	IF EXISTS
			(SELECT 1
			 FROM  factfind..TAssets assets
			 WHERE assets.AddressId = @AddressId AND assets.AssetsId <> @AssetsId)
	RETURN 1

	IF EXISTS
			(SELECT 1
			 FROM policymanagement..TMortgage mortgage
			 WHERE mortgage.AddressId = @AddressId AND mortgage.PolicyBusinessId <> @MortgageId)
	RETURN 1

	IF EXISTS
			(SELECT 1
			 FROM policymanagement..TEquityRelease equityRelease 
			 WHERE equityRelease.AddressId = @AddressId AND equityRelease.PolicyBusinessId <> @EquityReleaseId)
	RETURN 1

	IF EXISTS 
			(SELECT 1
			FROM
			(SELECT  
				((SELECT 
				    Mortgage.N.query('./SelectedAddress').value('.', 'int') AS SelectedAddress
				FROM DetailsXml.nodes('/PlanDetails/Mortgage') AS Mortgage(N)) 
				UNION ALL
				(SELECT 
				    EquityRelease.N.query('./SelectedAddress').value('.', 'int') AS SelectedAddress
				FROM DetailsXml.nodes('/PlanDetails/EquityRelease') AS EquityRelease(N)))
				AS AddressId
			 FROM factfind..TManualRecommendationAction mra
			 JOIN factfind..TManualRecommendation mr ON mra.ManualRecommendationId = mr.ManualRecommendationId
			 JOIN factfind..TFinancialPlanning fp ON mr.FinancialPlanningSessionId = fp.FinancialPlanningId
			 JOIN factfind..TFactFind ff ON fp.FactFindId = ff.FactFindId
			 JOIN crm..TAddress a ON ff.CRMContactId1 = a.CRMContactId AND a.AddressId = @AddressId) ids
			 WHERE ids.AddressId = @AddressId)
	RETURN 1

	RETURN 0
	END