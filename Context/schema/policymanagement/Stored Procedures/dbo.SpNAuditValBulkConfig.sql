SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditValBulkConfig]
	@StampUser varchar (255),
	@ValBulkConfigId bigint,
	@StampAction char(1)
AS

INSERT INTO TValBulkConfigAudit
     ( [RefProdProviderId],[MatchingCriteria],[DownloadDay],[DownloadTime],[ProcessDay],[ProcessTime]
           ,[ProviderFileDateOffset],[URL],[RequestXSL],[FieldNames],[TransformXSL],[Protocol]
           ,[SupportedService],[SupportedFileTypeId],[SupportedDelimiter],[ConcurrencyId],[ValBulkConfigId]
		   ,[StampAction],[StampDateTime],[StampUser]) 
Select [RefProdProviderId],[MatchingCriteria],[DownloadDay],[DownloadTime],[ProcessDay],[ProcessTime]
           ,[ProviderFileDateOffset],[URL],[RequestXSL],[FieldNames],[TransformXSL],[Protocol]
           ,[SupportedService],[SupportedFileTypeId],[SupportedDelimiter],[ConcurrencyId], [ValBulkConfigId]
		   , @StampAction, GetDate(), @StampUser
FROM TValBulkConfig
WHERE ValBulkConfigId = @ValBulkConfigId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
