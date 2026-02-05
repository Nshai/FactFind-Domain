SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION  [dbo].[FnCustomRetrievePolicyContributionsToDate](@PolicyBusinessId bigint)
RETURNS money
AS
BEGIN
RETURN
(SELECT
	SUM(dbo.FnCustomRetrieveContributionToDate(PMI.StartDate, PMI.StopDate, PMI.RefFrequencyId, PMI.Amount))
FROM
	PolicyManagement..TPolicyBusiness PB WITH(NOLOCK)
	JOIN PolicyManagement..TPolicyMoneyIn PMI WITH(NOLOCK) ON PMI.PolicyBusinessId = PB.PolicyBusinessId
WHERE
	PB.PolicyBusinessId = @PolicyBusinessId
)
END
GO
