SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveAtrAssetAllocationChart]
	@AtrPortfolioGuid uniqueidentifier
AS
	SELECT
		A.Identifier AS Identifier,
		ISNULL(A.Allocation, 0) AS Allocation
	FROM
		TAtrAssetClassCombined A
	WHERE	
		A.AtrPortfolioGuid = @AtrPortfolioGuid
		AND ISNULL(A.Allocation, 0) > 0
	ORDER BY		
		Identifier
	FOR XML RAW
GO
