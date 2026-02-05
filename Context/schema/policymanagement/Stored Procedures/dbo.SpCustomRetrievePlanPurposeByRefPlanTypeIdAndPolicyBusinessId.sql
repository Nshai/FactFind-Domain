SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrievePlanPurposeByRefPlanTypeIdAndPolicyBusinessId]
@RefPlanTypeId bigint,
@IndigoClientId bigint,
@PolicyBusinessId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.PlanPurposeId AS [PlanPurpose!1!PlanPurposeId], 
    T1.Descriptor AS [PlanPurpose!1!Descriptor], 
    ISNULL(T1.MortgageRelatedfg, '') AS [PlanPurpose!1!MortgageRelatedfg], 
    T1.IndigoClientId AS [PlanPurpose!1!IndigoClientId], 
    T1.ConcurrencyId AS [PlanPurpose!1!ConcurrencyId], 
    NULL AS [PlanTypePurpose!2!PlanTypePurposeId], 
    NULL AS [PlanTypePurpose!2!RefPlanTypeId], 
    NULL AS [PlanTypePurpose!2!PlanPurposeId], 
    NULL AS [PlanTypePurpose!2!ConcurrencyId]
  FROM TPlanPurpose T1
  INNER JOIN TPlanTypePurpose TPlanTypePurpose
  ON T1.PlanPurposeId = TPlanTypePurpose.PlanPurposeId
  WHERE (TPlanTypePurpose.RefPlanTypeId = @RefPlanTypeId) AND 
        (T1.IndigoClientId = @IndigoClientId)

  UNION ALL

  SELECT
    2 AS Tag,
    1 AS Parent,
    T1.PlanPurposeId, 
    T1.Descriptor, 
    ISNULL(T1.MortgageRelatedfg, ''), 
    T1.IndigoClientId, 
    T1.ConcurrencyId, 
    T2.PlanTypePurposeId, 
    T2.RefPlanTypeId, 
    T2.PlanPurposeId, 
    T2.ConcurrencyId
  FROM TPlanTypePurpose T2
  INNER JOIN TPlanPurpose T1
  ON T2.PlanPurposeId = T1.PlanPurposeId
  INNER JOIN TPolicyBusinessPurpose T3
  ON T3.PlanPurposeId = T2.PlanPurposeId 
  WHERE (T2.RefPlanTypeId = @RefPlanTypeId) AND 
             (T1.IndigoClientId = @IndigoClientId) AND
             (T3.PolicyBusinessId = @PolicyBusinessId)

  ORDER BY [PlanPurpose!1!PlanPurposeId], [PlanTypePurpose!2!PlanTypePurposeId]

  FOR XML EXPLICIT

END
RETURN (0)






GO
