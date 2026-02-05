SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION  [dbo].[FnCustomRetrievePolicyWithdrawalsToDate](@PolicyBusinessId bigint)
RETURNS money
AS
BEGIN
RETURN
(SELECT
	SUM(dbo.FnCustomRetrieveContributionToDate(PMO.StartDate, PMO.StopDate, PMO.RefFrequencyId, PMO.Amount))
FROM
	PolicyManagement..TPolicyBusiness PB WITH(NOLOCK)
	JOIN PolicyManagement..TPolicyMoneyIn PMO WITH(NOLOCK) ON PMO.PolicyBusinessId = PB.PolicyBusinessId
WHERE
	PB.PolicyBusinessId = @PolicyBusinessId
)
END
GO
