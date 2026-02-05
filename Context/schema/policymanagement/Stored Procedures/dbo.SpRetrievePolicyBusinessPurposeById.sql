SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrievePolicyBusinessPurposeById]
@PolicyBusinessPurposeId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.PolicyBusinessPurposeId AS [PolicyBusinessPurpose!1!PolicyBusinessPurposeId], 
    T1.PlanPurposeId AS [PolicyBusinessPurpose!1!PlanPurposeId], 
    T1.PolicyBusinessId AS [PolicyBusinessPurpose!1!PolicyBusinessId], 
    T1.ConcurrencyId AS [PolicyBusinessPurpose!1!ConcurrencyId]
  FROM TPolicyBusinessPurpose T1

  WHERE (T1.PolicyBusinessPurposeId = @PolicyBusinessPurposeId)

  ORDER BY [PolicyBusinessPurpose!1!PolicyBusinessPurposeId]

  FOR XML EXPLICIT

END
RETURN (0)




GO
