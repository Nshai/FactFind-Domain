SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditValBulkSummary] 
	@StampUser varchar (255),
	@ValBulkSummaryId bigint,
	@StampAction char(1)
AS

INSERT INTO TValBulkSummaryAudit 
( IndigoClientId, ValScheduleItemId, RefProdProviderId, DocVersionId, 
		FailedItemsToUpload, TotalItems, MatchedItems, IsArchived,
		ConcurrencyId, ValBulkSummaryId, StampAction, StampDateTime, StampUser) 
Select IndigoClientId, ValScheduleItemId, RefProdProviderId, DocVersionId, 
		FailedItemsToUpload, TotalItems, MatchedItems, IsArchived, 
		ConcurrencyId, ValBulkSummaryId, @StampAction, GetDate(), @StampUser
FROM TValBulkSummary
WHERE ValBulkSummaryId = @ValBulkSummaryId

IF @@ERROR != 0 GOTO errh
RETURN (0)

errh:
RETURN (100)


GO
