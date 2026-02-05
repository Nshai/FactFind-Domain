SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrievePlanTypesAndSubTypes] @RetireFg bit
AS

BEGIN
 SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.RefPlanTypeId AS [RefPlanType!1!RefPlanTypeId], 
    IsNull(T1.PlanTypeName,'') AS [RefPlanType!1!PlanTypeName],
    Null AS [ProdSubType!2!ProdSubTypeId],
    Null AS [ProdSubType!2!ProdSubTypeName]

  FROM TRefPlanType T1

  WHERE T1.RetireFg = @RetireFg

  UNION

 SELECT
    2 AS Tag,
    1 AS Parent,
    T1.RefPlanTypeId AS [RefPlanType!1!RefPlanTypeId], 
    Null, 
    IsNull(T3.ProdSubTypeId,0),
    IsNull(T3.ProdSubTypeName,'')

  FROM TRefPlanType T1
  Inner Join TRefPlanType2ProdSubType T2 On T1.RefPlanTypeId = T2.RefPlanTypeId
  Inner Join TProdSubType T3 On T2.ProdSubTypeId = T3.ProdSubTypeId

  Order By [RefPlanType!1!RefPlanTypeId], [ProdSubType!2!ProdSubTypeId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
