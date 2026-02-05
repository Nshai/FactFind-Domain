SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditValProviderConfig]
	@StampUser varchar (255),
	@ValProviderConfigId bigint,
	@StampAction char(1)
AS

INSERT INTO TValProviderConfigAudit 
( RefProdProviderId, PostURL, OrigoResponderId, AuthenticationType, 
		IsAsynchronous, HowToXML, AllowRetry, RetryDelay, 
		BulkValuationType, FileAccessCredentialsRequired, PasswordEncryption, ScheduleDelay, 
		ConcurrencyId, 
	ValProviderConfigId, StampAction, StampDateTime, StampUser) 
Select RefProdProviderId, PostURL, OrigoResponderId, AuthenticationType, 
		IsAsynchronous, HowToXML, AllowRetry, RetryDelay, 
		BulkValuationType, FileAccessCredentialsRequired, PasswordEncryption, ScheduleDelay, 
		ConcurrencyId, 
	ValProviderConfigId, @StampAction, GetDate(), @StampUser
FROM TValProviderConfig
WHERE ValProviderConfigId = @ValProviderConfigId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
