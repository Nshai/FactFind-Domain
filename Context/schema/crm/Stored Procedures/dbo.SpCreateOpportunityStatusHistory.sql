SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateOpportunityStatusHistory]
	@StampUser varchar (255),
	@OpportunityId bigint, 
	@OpportunityStatusId bigint, 
	@DateOfChange datetime, 
	@ChangedByUserId bigint, 
	@CurrentStatusFG bit = 1	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	
	DECLARE @OpportunityStatusHistoryId bigint
			
	
	INSERT INTO TOpportunityStatusHistory (
		OpportunityId, 
		OpportunityStatusId, 
		DateOfChange, 
		ChangedByUserId, 
		CurrentStatusFG, 
		ConcurrencyId)
		
	VALUES(
		@OpportunityId, 
		@OpportunityStatusId, 
		@DateOfChange, 
		@ChangedByUserId, 
		@CurrentStatusFG,
		1)

	SELECT @OpportunityStatusHistoryId = SCOPE_IDENTITY()

	INSERT INTO TOpportunityStatusHistoryAudit (
		OpportunityId, 
		OpportunityStatusId, 
		DateOfChange, 
		ChangedByUserId, 
		CurrentStatusFG, 
		ConcurrencyId,
		OpportunityStatusHistoryId,
		StampAction,
    		StampDateTime,
    		StampUser)
	SELECT  
		OpportunityId, 
		OpportunityStatusId, 
		DateOfChange, 
		ChangedByUserId, 
		CurrentStatusFG, 
		ConcurrencyId,
		OpportunityStatusHistoryId,
		'C',
    		GetDate(),
    		@StampUser
	FROM TOpportunityStatusHistory
	WHERE OpportunityStatusHistoryId = @OpportunityStatusHistoryId

	EXEC SpRetrieveOpportunityStatusHistoryById @OpportunityStatusHistoryId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)

GO
