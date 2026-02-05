SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomRetrieveProvidersForFirmLevelValuation]
AS

BEGIN
  SELECT
    1 AS Tag,
    NULL AS Parent,
    T1.ValProviderConfigId AS [ValProviderConfig!1!ValProviderConfigId], 
    T1.RefProdProviderId AS [ValProviderConfig!1!RefProdProviderId], 
    T3.CorporateName AS [ValProviderConfig!1!ProviderName], 
    T1.PostURL AS [ValProviderConfig!1!PostURL], 
    T1.OrigoResponderId AS [ValProviderConfig!1!OrigoResponderId], 
    T1.AuthenticationType AS [ValProviderConfig!1!AuthenticationType], 
    T1.IsAsynchronous AS [ValProviderConfig!1!IsAsynchronous], 
    ISNULL(T1.HowToXML, '') AS [ValProviderConfig!1!HowToXML], 
    T1.AllowRetry AS [ValProviderConfig!1!AllowRetry], 
    ISNULL(T1.RetryDelay, '') AS [ValProviderConfig!1!RetryDelay], 
    ISNULL(T1.BulkValuationType, '') AS [ValProviderConfig!1!BulkValuationType], 
    T1.FileAccessCredentialsRequired AS [ValProviderConfig!1!FileAccessCredentialsRequired], 
    T1.ConcurrencyId AS [ValProviderConfig!1!ConcurrencyId]
  From PolicyManagement..TValProviderConfig T1
  Inner Join PolicyManagement..TRefProdProvider T2 On T1.RefProdProviderId = T2.RefProdProviderId
  Inner Join CRM..TCRMContact T3 On T2.CRMContactId = T3.CRMContactId

  WHERE T1.BulkValuationType IS NOT NULL

  ORDER BY [ValProviderConfig!1!ValProviderConfigId]

  FOR XML EXPLICIT

END
RETURN (0)
GO
