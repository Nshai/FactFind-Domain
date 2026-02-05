SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveAtrRefProfilePreference]

AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.AtrRefProfilePreferenceId AS [AtrRefProfilePreference!1!AtrRefProfilePreferenceId], 
	ISNULL(T1.Identifier, '') AS [AtrRefProfilePreference!1!Identifier], 
	ISNULL(T1.Descriptor, '') AS [AtrRefProfilePreference!1!Descriptor], 
	T1.ConcurrencyId AS [AtrRefProfilePreference!1!ConcurrencyId]
	FROM TAtrRefProfilePreference T1
	ORDER BY [AtrRefProfilePreference!1!AtrRefProfilePreferenceId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
