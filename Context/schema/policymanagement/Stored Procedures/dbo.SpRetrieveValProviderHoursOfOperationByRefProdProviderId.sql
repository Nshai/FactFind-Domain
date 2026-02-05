SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[SpRetrieveValProviderHoursOfOperationByRefProdProviderId]
@RefProdProviderId bigint
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.ValProviderHoursOfOperationId AS [ValProviderHoursOfOperation!1!ValProviderHoursOfOperationId], 
    T1.RefProdProviderId AS [ValProviderHoursOfOperation!1!RefProdProviderId], 
    T1.AlwaysAvailableFg AS [ValProviderHoursOfOperation!1!AlwaysAvailableFg], 
    ISNULL(T1.DayOfTheWeek, '') AS [ValProviderHoursOfOperation!1!DayOfTheWeek], 
    T1.StartHour AS [ValProviderHoursOfOperation!1!StartHour], 
    T1.EndHour AS [ValProviderHoursOfOperation!1!EndHour], 
    T1.StartMinute AS [ValProviderHoursOfOperation!1!StartMinute], 
    T1.EndMinute AS [ValProviderHoursOfOperation!1!EndMinute], 
    T1.ConcurrencyId AS [ValProviderHoursOfOperation!1!ConcurrencyId]
  FROM TValProviderHoursOfOperation T1

  WHERE (T1.RefProdProviderId = @RefProdProviderId)

  ORDER BY [ValProviderHoursOfOperation!1!ValProviderHoursOfOperationId]

  FOR XML EXPLICIT

END
RETURN (0)

GO
