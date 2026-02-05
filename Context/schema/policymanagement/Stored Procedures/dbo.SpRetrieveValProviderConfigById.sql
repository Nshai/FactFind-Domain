SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveValProviderConfigById]   
	@ValProviderConfigId bigint  
AS    
BEGIN   
	SELECT   
		1 AS Tag,   
		NULL AS Parent,   
		T1.ValProviderConfigId AS [ValProviderConfig!1!ValProviderConfigId],    
		T1.RefProdProviderId AS [ValProviderConfig!1!RefProdProviderId],    
		T1.PostURL AS [ValProviderConfig!1!PostURL],    
		T1.OrigoResponderId AS [ValProviderConfig!1!OrigoResponderId],    
		T1.AuthenticationType AS [ValProviderConfig!1!AuthenticationType],    
		T1.IsAsynchronous AS [ValProviderConfig!1!IsAsynchronous],    
		ISNULL(T1.HowToXML, '') AS [ValProviderConfig!1!HowToXML],    
		T1.AllowRetry AS [ValProviderConfig!1!AllowRetry],    
		ISNULL(T1.RetryDelay, '') AS [ValProviderConfig!1!RetryDelay],    
		ISNULL(T1.BulkValuationType, '') AS [ValProviderConfig!1!BulkValuationType],    
		T1.FileAccessCredentialsRequired AS [ValProviderConfig!1!FileAccessCredentialsRequired],    
		ISNULL(T1.PasswordEncryption, '') AS [ValProviderConfig!1!PasswordEncryption],    
		T1.ScheduleDelay AS [ValProviderConfig!1!ScheduleDelay],    
		T1.SupportedService AS [ValProviderConfig!1!SupportedService],
		T1.ConcurrencyId AS [ValProviderConfig!1!ConcurrencyId]   
	FROM TValProviderConfig T1      
	WHERE T1.ValProviderConfigId = @ValProviderConfigId   
	ORDER BY [ValProviderConfig!1!ValProviderConfigId]      
	FOR XML EXPLICIT    
END  
RETURN (0)



GO
