SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveRefCommissionType]
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.RefCommissionTypeId AS [RefCommissionType!1!RefCommissionTypeId], 
    ISNULL(T1.CommissionTypeName, '') AS [RefCommissionType!1!CommissionTypeName], 
    ISNULL(T1.OrigoRef, '') AS [RefCommissionType!1!OrigoRef], 
    ISNULL(T1.InitialCommissionFg, '') AS [RefCommissionType!1!InitialCommissionFg], 
    ISNULL(T1.RecurringCommissionFg, '') AS [RefCommissionType!1!RecurringCommissionFg], 
    ISNULL(T1.RetireFg, '') AS [RefCommissionType!1!RetireFg], 
    T1.ConcurrencyId AS [RefCommissionType!1!ConcurrencyId]
  FROM TRefCommissionType T1

  ORDER BY [RefCommissionType!1!RefCommissionTypeId]

  FOR XML EXPLICIT

END
RETURN (0)




GO
