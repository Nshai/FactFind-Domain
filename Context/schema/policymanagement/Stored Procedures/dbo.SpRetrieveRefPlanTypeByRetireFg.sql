SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveRefPlanTypeByRetireFg]
@RetireFg tinyint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.RefPlanTypeId AS [RefPlanType!1!RefPlanTypeId], 
    T1.PlanTypeName AS [RefPlanType!1!PlanTypeName], 
    ISNULL(T1.WebPage, '') AS [RefPlanType!1!WebPage], 
    ISNULL(T1.OrigoRef, '') AS [RefPlanType!1!OrigoRef], 
    ISNULL(T1.QuoteRef, '') AS [RefPlanType!1!QuoteRef], 
    ISNULL(T1.NBRef, '') AS [RefPlanType!1!NBRef], 
    ISNULL(T1.RetireFg, '') AS [RefPlanType!1!RetireFg], 
    ISNULL(CONVERT(varchar(24), T1.RetireDate, 120),'') AS [RefPlanType!1!RetireDate], 
    ISNULL(T1.FindFg, '') AS [RefPlanType!1!FindFg], 
    T1.SchemeType AS [RefPlanType!1!SchemeType], 
    T1.ConcurrencyId AS [RefPlanType!1!ConcurrencyId]
  FROM TRefPlanType T1

  WHERE (T1.RetireFg = @RetireFg)

  ORDER BY [RefPlanType!1!RefPlanTypeId]

  FOR XML EXPLICIT

END
RETURN (0)




GO
