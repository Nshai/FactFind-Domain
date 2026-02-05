SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveOrganisationStatusHistoryById]
@OrganisationStatusHistoryId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.OrganisationStatusHistoryId AS [OrganisationStatusHistory!1!OrganisationStatusHistoryId], 
    T1.IndigoClientId AS [OrganisationStatusHistory!1!IndigoClientId], 
    T1.Identifier AS [OrganisationStatusHistory!1!Identifier], 
    CONVERT(varchar(24), T1.ChangeDateTime, 120) AS [OrganisationStatusHistory!1!ChangeDateTime], 
    T1.ChangeUser AS [OrganisationStatusHistory!1!ChangeUser], 
    T1.ConcurrencyId AS [OrganisationStatusHistory!1!ConcurrencyId]
  FROM TOrganisationStatusHistory T1

  WHERE (T1.OrganisationStatusHistoryId = @OrganisationStatusHistoryId)

  ORDER BY [OrganisationStatusHistory!1!OrganisationStatusHistoryId]

  FOR XML EXPLICIT

END
RETURN (0)


GO
