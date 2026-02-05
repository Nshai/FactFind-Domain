SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpRetrieveValBulkConfigById]
	@ValBulkConfigId bigint  
AS    

BEGIN   

SELECT   
	1 AS Tag,   
	NULL AS Parent,   
	T1.ValBulkConfigId AS [ValBulkConfig!1!ValBulkConfigId],    
	T1.RefProdProviderId AS [ValBulkConfig!1!RefProdProviderId],    
	ISNULL(T1.MatchingCriteria, '') AS [ValBulkConfig!1!MatchingCriteria],    
	ISNULL(T1.DownloadDay, '') AS [ValBulkConfig!1!DownloadDay],    
	ISNULL(T1.DownloadTime, '') AS [ValBulkConfig!1!DownloadTime],    
	ISNULL(T1.ProcessDay, '') AS [ValBulkConfig!1!ProcessDay],    
	ISNULL(T1.ProcessTime, '') AS [ValBulkConfig!1!ProcessTime],    
	ISNULL(T1.ProviderFileDateOffset, 0) AS [ValBulkConfig!1!ProviderFileDateOffset],    
	ISNULL(T1.URL, '') AS [ValBulkConfig!1!URL],    
	ISNULL(T1.RequestXSL, '') AS [ValBulkConfig!1!RequestXSL],    
	ISNULL(T1.FieldNames, '') AS [ValBulkConfig!1!FieldNames],    
	ISNULL(T1.TransformXSL, '') AS [ValBulkConfig!1!TransformXSL],
	ISNULL(T1.Protocol, '') AS [ValBulkConfig!1!Protocol],      
	ISNULL(T1.SupportedService, 0) AS [ValBulkConfig!1!SupportedService],
	ISNULL(T1.SupportedFileTypeId, 0) AS [ValBulkConfig!1!SupportedFileTypeId],
	ISNULL(T1.SupportedDelimiter, '|') AS [ValBulkConfig!1!SupportedDelimiter],
	T1.ConcurrencyId AS [ValBulkConfig!1!ConcurrencyId]   

FROM TValBulkConfig T1      
WHERE T1.ValBulkConfigId = @ValBulkConfigId   
ORDER BY [ValBulkConfig!1!ValBulkConfigId]      
FOR XML EXPLICIT    
END  
RETURN (0)

GO
