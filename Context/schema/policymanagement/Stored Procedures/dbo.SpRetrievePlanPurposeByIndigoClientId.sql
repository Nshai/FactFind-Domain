SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrievePlanPurposeByIndigoClientId]
@IndigoClientId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.PlanPurposeId AS [PlanPurpose!1!PlanPurposeId], 
    T1.Descriptor AS [PlanPurpose!1!Descriptor], 
    ISNULL(T1.MortgageRelatedfg, '') AS [PlanPurpose!1!MortgageRelatedfg], 
    T1.IndigoClientId AS [PlanPurpose!1!IndigoClientId], 
    T1.ConcurrencyId AS [PlanPurpose!1!ConcurrencyId]
  FROM TPlanPurpose T1

  WHERE (T1.IndigoClientId = @IndigoClientId)

  ORDER BY [PlanPurpose!1!PlanPurposeId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
