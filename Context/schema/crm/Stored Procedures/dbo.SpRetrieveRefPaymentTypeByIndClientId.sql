SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveRefPaymentTypeByIndClientId]
@IndClientId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.RefPaymentTypeId AS [RefPaymentType!1!RefPaymentTypeId], 
    T1.IndClientId AS [RefPaymentType!1!IndClientId], 
    T1.Name AS [RefPaymentType!1!Name], 
    ISNULL(T1.Description, '') AS [RefPaymentType!1!Description], 
    T1.ActiveFG AS [RefPaymentType!1!ActiveFG], 
    T1.ConcurrencyId AS [RefPaymentType!1!ConcurrencyId]
  FROM TRefPaymentType T1

  WHERE (T1.IndClientId = @IndClientId)

  ORDER BY [RefPaymentType!1!RefPaymentTypeId]

  FOR XML EXPLICIT

END
RETURN (0)









GO
