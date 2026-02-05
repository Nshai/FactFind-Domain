SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveClientActivityLogById]
	@ClientActivityLogId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.ClientActivityLogId AS [ClientActivityLog!1!ClientActivityLogId], 
	T1.CRMContactId AS [ClientActivityLog!1!CRMContactId], 
	ISNULL(T1.Activity, '') AS [ClientActivityLog!1!Activity], 
	ISNULL(T1.Application, '') AS [ClientActivityLog!1!Application], 
	CONVERT(varchar(24), T1.TimeStamp, 120) AS [ClientActivityLog!1!TimeStamp], 
	T1.ConcurrencyId AS [ClientActivityLog!1!ConcurrencyId]
	FROM TClientActivityLog T1
	
	WHERE T1.ClientActivityLogId = @ClientActivityLogId
	ORDER BY [ClientActivityLog!1!ClientActivityLogId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
