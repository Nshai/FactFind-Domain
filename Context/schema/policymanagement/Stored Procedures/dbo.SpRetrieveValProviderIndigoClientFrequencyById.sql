SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveValProviderIndigoClientFrequencyById]
	@ValProviderIndigoClientFrequencyId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.ValProviderIndigoClientFrequencyId AS [ValProviderIndigoClientFrequency!1!ValProviderIndigoClientFrequencyId], 
	T1.RefProdProviderId AS [ValProviderIndigoClientFrequency!1!RefProdProviderId], 
	T1.IndigoClientId AS [ValProviderIndigoClientFrequency!1!IndigoClientId], 
	T1.AllowDaily AS [ValProviderIndigoClientFrequency!1!AllowDaily], 
	T1.AllowWeekly AS [ValProviderIndigoClientFrequency!1!AllowWeekly], 
	T1.AllowFortnightly AS [ValProviderIndigoClientFrequency!1!AllowFortnightly], 
	T1.AllowMonthly AS [ValProviderIndigoClientFrequency!1!AllowMonthly], 
	T1.AllowBiAnnually AS [ValProviderIndigoClientFrequency!1!AllowBiAnnually], 
	T1.AllowQuarterly AS [ValProviderIndigoClientFrequency!1!AllowQuarterly], 
	T1.AllowHalfYearly AS [ValProviderIndigoClientFrequency!1!AllowHalfYearly], 
	T1.AllowAnnually AS [ValProviderIndigoClientFrequency!1!AllowAnnually], 
	T1.ConcurrencyId AS [ValProviderIndigoClientFrequency!1!ConcurrencyId]
	FROM TValProviderIndigoClientFrequency T1
	
	WHERE T1.ValProviderIndigoClientFrequencyId = @ValProviderIndigoClientFrequencyId
	ORDER BY [ValProviderIndigoClientFrequency!1!ValProviderIndigoClientFrequencyId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
