SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION  [dbo].[FnCustomGetPlanValuationFromValuationTab](@PolicyBusinessId bigint)
RETURNS money
AS
BEGIN
RETURN (
	SELECT TOP 1 
		PlanValue
	FROM
		TPlanValuation WITH(NOLOCK)
	WHERE
		PolicyBusinessId = @PolicyBusinessId
	ORDER BY
		-- Remove time part from the valuation date when we sort, this is 
		-- because electronic valuations store the date but manual vals do not.
		DATEADD(d, DATEDIFF(d, 0, PlanValueDate), 0) DESC,
		PlanValuationId DESC
	)
END
GO
