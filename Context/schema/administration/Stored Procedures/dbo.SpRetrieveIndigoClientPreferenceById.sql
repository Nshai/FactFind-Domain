SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveIndigoClientPreferenceById]
	@IndigoClientPreferenceId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.IndigoClientPreferenceId AS [IndigoClientPreference!1!IndigoClientPreferenceId], 
	T1.IndigoClientId AS [IndigoClientPreference!1!IndigoClientId], 
	T1.IndigoClientGuid AS [IndigoClientPreference!1!IndigoClientGuid], 
	T1.PreferenceName AS [IndigoClientPreference!1!PreferenceName], 
	ISNULL(T1.Value, '') AS [IndigoClientPreference!1!Value], 
	T1.Disabled AS [IndigoClientPreference!1!Disabled], 
	T1.ConcurrencyId AS [IndigoClientPreference!1!ConcurrencyId]
	FROM TIndigoClientPreference T1
	
	WHERE T1.IndigoClientPreferenceId = @IndigoClientPreferenceId
	ORDER BY [IndigoClientPreference!1!IndigoClientPreferenceId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
