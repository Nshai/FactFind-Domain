SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveValScheduleConfigById]
	@ValScheduleConfigId bigint
AS

BEGIN
	SELECT
	1 AS Tag,
	NULL AS Parent,
	T1.ValScheduleConfigId AS [ValScheduleConfig!1!ValScheduleConfigId], 
	T1.RefProdProviderId AS [ValScheduleConfig!1!RefProdProviderId], 
	ISNULL(T1.ScheduleStartTime, '') AS [ValScheduleConfig!1!ScheduleStartTime], 
	T1.IsEnabled AS [ValScheduleConfig!1!IsEnabled], 
	T1.ConcurrencyId AS [ValScheduleConfig!1!ConcurrencyId]
	FROM TValScheduleConfig T1
	
	WHERE T1.ValScheduleConfigId = @ValScheduleConfigId
	ORDER BY [ValScheduleConfig!1!ValScheduleConfigId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
