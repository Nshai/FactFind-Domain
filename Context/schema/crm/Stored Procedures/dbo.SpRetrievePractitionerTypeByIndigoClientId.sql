SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrievePractitionerTypeByIndigoClientId]
@IndigoClientId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.PractitionerTypeId AS [PractitionerType!1!PractitionerTypeId], 
    T1.IndigoClientId AS [PractitionerType!1!IndigoClientId], 
    T1.Description AS [PractitionerType!1!Description], 
    CONVERT(varchar(24), T1.CreatedDate, 120) AS [PractitionerType!1!CreatedDate], 
    T1.ConcurrencyId AS [PractitionerType!1!ConcurrencyId]
  FROM TPractitionerType T1

  WHERE (T1.IndigoClientId = @IndigoClientId)

  ORDER BY [PractitionerType!1!PractitionerTypeId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
