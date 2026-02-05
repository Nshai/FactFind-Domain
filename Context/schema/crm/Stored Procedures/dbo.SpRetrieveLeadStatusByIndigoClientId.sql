SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveLeadStatusByIndigoClientId]
@IndigoClientId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.LeadStatusId AS [LeadStatus!1!LeadStatusId], 
    T1.Descriptor AS [LeadStatus!1!Descriptor], 
    T1.CanConvertToClientFG AS [LeadStatus!1!CanConvertToClientFG], 
    T1.OrderNumber AS [LeadStatus!1!OrderNumber], 
    T1.IndigoClientId AS [LeadStatus!1!IndigoClientId], 
    T1.ConcurrencyId AS [LeadStatus!1!ConcurrencyId]
  FROM TLeadStatus T1

  WHERE (T1.IndigoClientId = @IndigoClientId)

  ORDER BY [LeadStatus!1!LeadStatusId]

  FOR XML EXPLICIT

END
RETURN (0)


GO
