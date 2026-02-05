SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveRefMortgageBorrowerTypeById]
@RefMortgageBorrowerTypeId bigint
AS

--Raiserror('If you see this error SpRetrieveRefMortgageBorrowerTypeById needs fixing', 16,1)


BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.RefMortgageBorrowerTypeId AS [RefMortgageBorrowerType!1!RefMortgageBorrowerTypeId], 
    T1.MortgageBorrowerType AS [RefMortgageBorrowerType!1!MortgageBorrowerType], 
    T1.ConcurrencyId AS [RefMortgageBorrowerType!1!ConcurrencyId]
  FROM TRefMortgageBorrowerType T1

  WHERE (T1.RefMortgageBorrowerTypeId = @RefMortgageBorrowerTypeId)

  ORDER BY [RefMortgageBorrowerType!1!RefMortgageBorrowerTypeId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
