SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION  [dbo].[FnCustomGetPlanValuationFromFunds](@PolicyBusinessId bigint)
RETURNS money
AS
BEGIN
RETURN (
	SELECT
		SUM(Funds.[Value])
	FROM (
		SELECT
			ISNULL(CurrentUnitQuantity * CurrentPrice, 0) AS [Value]
		FROM
			TPolicyBusinessFund	WITH(NOLOCK)
		WHERE
			PolicyBusinessId = @PolicyBusinessId
		
		UNION ALL
		SELECT
			ISNULL(Amount, 0)
		FROM
			FactFind..TAssets A WITH(NOLOCK)
		WHERE
			PolicyBusinessId = @PolicyBusinessId
			-- Asset must be linked to a category - this ensures consistency with Plan Funds tab
			AND AssetCategoryId IS NOT NULL) AS Funds
)			
END

GO
