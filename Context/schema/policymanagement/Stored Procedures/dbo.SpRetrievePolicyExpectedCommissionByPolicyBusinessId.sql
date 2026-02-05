SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrievePolicyExpectedCommissionByPolicyBusinessId]
@PolicyBusinessId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.PolicyExpectedCommissionId AS [PolicyExpectedCommission!1!PolicyExpectedCommissionId], 
    T1.PolicyBusinessId AS [PolicyExpectedCommission!1!PolicyBusinessId], 
    T1.RefCommissionTypeId AS [PolicyExpectedCommission!1!RefCommissionTypeId], 
    T1.RefPaymentDueTypeId AS [PolicyExpectedCommission!1!RefPaymentDueTypeId], 
    ISNULL(T1.RefFrequencyId, '') AS [PolicyExpectedCommission!1!RefFrequencyId], 
    ISNULL(T1.ChargingPeriodMonths, '') AS [PolicyExpectedCommission!1!ChargingPeriodMonths], 
    T1.ExpectedAmount AS [PolicyExpectedCommission!1!ExpectedAmount], 
    ISNULL(CONVERT(varchar(24), T1.ExpectedStartDate, 120),'') AS [PolicyExpectedCommission!1!ExpectedStartDate], 
    T1.ExpectedCommissionType AS [PolicyExpectedCommission!1!ExpectedCommissionType], 
    ISNULL(T1.ParentPolicyExpectedCommissionId, '') AS [PolicyExpectedCommission!1!ParentPolicyExpectedCommissionId], 
    T1.ConcurrencyId AS [PolicyExpectedCommission!1!ConcurrencyId]
  FROM TPolicyExpectedCommission T1

  WHERE (T1.PolicyBusinessId = @PolicyBusinessId)

  ORDER BY [PolicyExpectedCommission!1!PolicyExpectedCommissionId]

  FOR XML EXPLICIT

END
RETURN (0)




GO
