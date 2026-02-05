SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE SpCustomGetPolicyFundCategory
    @PolicyBusinessIds VARCHAR(8000),
    @TenantId BIGINT
AS

    DECLARE @pbs TABLE(PolicyBusinessId INT)

    INSERT INTO @pbs(PolicyBusinessId)
    SELECT
        CAST(ISNULL(Value, '0') AS INT)
    FROM policymanagement..FnSplit(@PolicyBusinessIds, ',')

    SELECT
        pbs.PolicyBusinessId AS PolicyBusinessId,
        pbf.PolicyBusinessFundId AS PolicyFundId,
        pbf.CategoryName AS CategoryName
    FROM @pbs pbs
       INNER JOIN policymanagement..TPolicyBusinessFund pbf ON pbf.PolicyBusinessId = pbs.PolicyBusinessId AND pbf.FundIndigoClientId = @TenantId

