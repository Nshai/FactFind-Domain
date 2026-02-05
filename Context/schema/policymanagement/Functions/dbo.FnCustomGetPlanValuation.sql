SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION  [dbo].[FnCustomGetPlanValuation](@PolicyBusinessId bigint)
RETURNS money
AS
BEGIN
DECLARE @Valuation money

-- Try to get valuation from funds and holdings
SELECT @Valuation = PolicyManagement.dbo.FnCustomGetPlanValuationFromFunds(@PolicyBusinessId)
-- If no valuation is found then use valuation tab
IF @Valuation IS NULL
	SELECT @Valuation = PolicyManagement.dbo.FnCustomGetPlanValuationFromValuationTab(@PolicyBusinessId)
	
RETURN 
	@Valuation
END
GO
