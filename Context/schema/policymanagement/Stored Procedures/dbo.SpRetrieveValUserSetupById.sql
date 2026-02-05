SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveValUserSetupById]
	@ValUserSetupId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.ValUserSetupId AS [ValUserSetup!1!ValUserSetupId], 
	T1.UserId AS [ValUserSetup!1!UserId], 
	T1.UseValuationFundsFg AS [ValUserSetup!1!UseValuationFundsFg], 
	T1.UseValuationAssetsFg AS [ValUserSetup!1!UseValuationAssetsFg], 
	T1.ConcurrencyId AS [ValUserSetup!1!ConcurrencyId]
	FROM TValUserSetup T1
	
	WHERE T1.ValUserSetupId = @ValUserSetupId
	ORDER BY [ValUserSetup!1!ValUserSetupId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
