SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateValBulkConfig]   
	@StampUser varchar (255), 
	@RefProdProviderId bigint, 
	@MatchingCriteria varchar(255) = NULL,    
	@DownloadDay varchar(25) = NULL,    
	@DownloadTime varchar(25) = NULL,    
	@ProcessDay varchar(25) = NULL,    
	@ProcessTime varchar(25) = NULL,   
	@ProviderFileDateOffset smallint = 0,   
	@URL varchar(255) = NULL,    
	@RequestXSL varchar(3400) = NULL,    
	@FieldNames varchar(2000) = NULL,    
	@TransformXSL varchar(MAX) = NULL,
	@Protocol varchar(50) = 'https',
	@SupportedService int = 0,
	@SupportedFileTypeId bigint = NULL,
	@SupportedDelimiter varchar(25) = '|'
	
AS    

SET NOCOUNT ON    

DECLARE @tx int  

SELECT @tx = @@TRANCOUNT  
IF @tx = 0 BEGIN TRANSACTION TX    

BEGIN      

	DECLARE @ValBulkConfigId bigint           

	INSERT INTO TValBulkConfig (RefProdProviderId, MatchingCriteria, 
		DownloadDay, DownloadTime, ProcessDay, ProcessTime, ProviderFileDateOffset, 
		URL, RequestXSL, FieldNames, TransformXSL, Protocol, SupportedService, SupportedFileTypeId, SupportedDelimiter, ConcurrencyId)       
		
	VALUES(@RefProdProviderId, @MatchingCriteria, 
		@DownloadDay, @DownloadTime, @ProcessDay, @ProcessTime, @ProviderFileDateOffset,    
		@URL, @RequestXSL, @FieldNames, @TransformXSL, @Protocol, @SupportedService, @SupportedFileTypeId, @SupportedDelimiter, 1)     
		
	SELECT @ValBulkConfigId = SCOPE_IDENTITY()      

	INSERT INTO TValBulkConfigAudit (RefProdProviderId, MatchingCriteria,
		 DownloadDay, DownloadTime, ProcessDay, ProcessTime, ProviderFileDateOffset,    
		 URL, RequestXSL, FieldNames, TransformXSL, Protocol, SupportedService, SupportedFileTypeId, SupportedDelimiter, ConcurrencyId,    
		 ValBulkConfigId, StampAction, StampDateTime, StampUser)   

	SELECT  RefProdProviderId, MatchingCriteria, 
		DownloadDay, DownloadTime, ProcessDay, ProcessTime, ProviderFileDateOffset,    
		URL, RequestXSL, FieldNames, TransformXSL, Protocol, @SupportedService, @SupportedFileTypeId, @SupportedDelimiter, ConcurrencyId,    
		ValBulkConfigId, 'C', GetDate(), @StampUser   
	FROM TValBulkConfig   
	WHERE ValBulkConfigId = @ValBulkConfigId   

	EXEC SpRetrieveValBulkConfigById @ValBulkConfigId    

	IF @@ERROR != 0 GOTO errh  
	IF @tx = 0 COMMIT TRANSACTION TX    
END  
RETURN (0)    

errh:    
IF @tx = 0 ROLLBACK TRANSACTION TX    
RETURN (100)

GO
