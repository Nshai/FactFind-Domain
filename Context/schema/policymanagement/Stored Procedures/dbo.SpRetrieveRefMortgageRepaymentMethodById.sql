SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveRefMortgageRepaymentMethodById]
@RefMortgageRepaymentMethodId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.RefMortgageRepaymentMethodId AS [RefMortgageRepaymentMethod!1!RefMortgageRepaymentMethodId], 
    T1.MortgageRepaymentMethod AS [RefMortgageRepaymentMethod!1!MortgageRepaymentMethod], 
    T1.IndigoClientId AS [RefMortgageRepaymentMethod!1!IndigoClientId], 
    T1.ConcurrencyId AS [RefMortgageRepaymentMethod!1!ConcurrencyId]
  FROM TRefMortgageRepaymentMethod T1

  WHERE (T1.RefMortgageRepaymentMethodId = @RefMortgageRepaymentMethodId)

  ORDER BY [RefMortgageRepaymentMethod!1!RefMortgageRepaymentMethodId]

  FOR XML EXPLICIT

END
RETURN (0)


GO
