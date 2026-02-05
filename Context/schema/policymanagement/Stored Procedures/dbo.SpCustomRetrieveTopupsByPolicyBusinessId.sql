SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveTopupsByPolicyBusinessId]
	@PolicyBusinessId bigint,
	@TenantId bigint
AS
-- Get detail id
DECLARE @PolicyDetailId bigint, @MainId bigint
SELECT @PolicyDetailId = PolicyDetailId FROM TPolicyBusiness WHERE PolicyBusinessId = @PolicyBusinessId AND IndigoClientId = @TenantId
-- get main plan id
SELECT @MainId = MIN(PolicyBusinessId) FROM TPolicyBusiness WHERE PolicyDetailId = @PolicyDetailId
-- Retrieve Topup for this plan.
SELECT 
	PB.*
FROM
	TPolicyBusiness PB
	JOIN TStatusHistory SH ON SH.PolicyBusinessId = PB.PolicyBusinessId AND CurrentStatusFg = 1
	JOIN TStatus S ON S.StatusId = SH.StatusId AND S.IntelligentOfficeStatusType != 'Deleted'
WHERE
	Pb.PolicyDetailId = @PolicyDetailId
	-- make sure that supplied plan is the main policy record.
	AND @MainId = @PolicyBusinessId
	-- return topups
	AND PB.PolicyBusinessId != @MainId
FOR XML RAW('PolicyBusiness')
GO
