SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveValPortalSetupById]
	@ValPortalSetupId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.ValPortalSetupId AS [ValPortalSetup!1!ValPortalSetupId], 
	T1.CRMContactId AS [ValPortalSetup!1!CRMContactId], 
	T1.RefProdProviderId AS [ValPortalSetup!1!RefProdProviderId], 
	ISNULL(T1.UserName, '') AS [ValPortalSetup!1!UserName], 
	ISNULL(T1.Password, '') AS [ValPortalSetup!1!Password], 
	T1.ShowHowToScreen AS [ValPortalSetup!1!ShowHowToScreen], 
	ISNULL(CONVERT(varchar(24), T1.CreatedDate, 120), '') AS [ValPortalSetup!1!CreatedDate], 
	T1.ConcurrencyId AS [ValPortalSetup!1!ConcurrencyId]
	FROM TValPortalSetup T1
	
	WHERE T1.ValPortalSetupId = @ValPortalSetupId
	ORDER BY [ValPortalSetup!1!ValPortalSetupId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
