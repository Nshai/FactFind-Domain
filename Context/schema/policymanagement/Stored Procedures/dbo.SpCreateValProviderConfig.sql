SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateValProviderConfig]   
	@StampUser varchar (255),   
	@RefProdProviderId bigint,    
	@PostURL varchar(500) ,    
	@OrigoResponderId varchar(255) ,    
	@AuthenticationType tinyint = 0,    
	@IsAsynchronous bit = 0,    
	@HowToXML varchar(6000)  = NULL,    
	@AllowRetry bit = 0,    
	@RetryDelay int = NULL,    
	@BulkValuationType varchar(100)  = NULL,    
	@FileAccessCredentialsRequired bit = 0,    
	@PasswordEncryption varchar(50)  = NULL,    
	@ScheduleDelay int = 0,
	@SupportedService int = 0
AS    

SET NOCOUNT ON    

DECLARE @tx int  

SELECT @tx = @@TRANCOUNT  
IF @tx = 0 BEGIN TRANSACTION TX    

BEGIN      

	DECLARE @ValProviderConfigId bigint           
	
	INSERT INTO TValProviderConfig (
		RefProdProviderId,     
		PostURL,     
		OrigoResponderId,     
		AuthenticationType,     
		IsAsynchronous,     
		HowToXML,     
		AllowRetry,     
		RetryDelay,     
		BulkValuationType,     
		FileAccessCredentialsRequired,     
		PasswordEncryption,     
		ScheduleDelay,
		SupportedService,     
		ConcurrencyId)       
	VALUES(
		@RefProdProviderId,     
		@PostURL,     
		@OrigoResponderId,     
		@AuthenticationType,     
		@IsAsynchronous,     
		@HowToXML,     
		@AllowRetry,     
		@RetryDelay,     
		@BulkValuationType,     
		@FileAccessCredentialsRequired,     
		@PasswordEncryption,
		@ScheduleDelay,  
		@SupportedService,  
		1)     
	
	SELECT @ValProviderConfigId = SCOPE_IDENTITY()      
	
	INSERT INTO TValProviderConfigAudit (    
		RefProdProviderId,     
		PostURL,     
		OrigoResponderId,     
		AuthenticationType,     
		IsAsynchronous,     
		HowToXML,     
		AllowRetry,     
		RetryDelay,     
		BulkValuationType,     
		FileAccessCredentialsRequired,     
		PasswordEncryption,
		ScheduleDelay,    
		SupportedService, 
		ConcurrencyId,    
		ValProviderConfigId,    
		StampAction,       
		StampDateTime,       
		StampUser)   
	SELECT      
		RefProdProviderId,     
		PostURL,     
		OrigoResponderId,     
		AuthenticationType,     
		IsAsynchronous,     
		HowToXML,     
		AllowRetry,     
		RetryDelay,     
		BulkValuationType,     
		FileAccessCredentialsRequired,     
		PasswordEncryption,     
		ScheduleDelay,   
		SupportedService,  
		ConcurrencyId,    
		ValProviderConfigId,    
		'C',       
		GetDate(),       
		@StampUser   
	FROM TValProviderConfig   
	WHERE ValProviderConfigId = @ValProviderConfigId   
	
	EXEC SpRetrieveValProviderConfigById @ValProviderConfigId    
	
	IF @@ERROR != 0 GOTO errh  
	IF @tx = 0 COMMIT TRANSACTION TX    
END  
RETURN (0)    

errh:    
IF @tx = 0 ROLLBACK TRANSACTION TX    
RETURN (100)

GO
