SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateOpportunityObjective]
	@StampUser varchar (255),
	@OpportunityId bigint = NULL, 
	@ObjectiveId bigint = NULL	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	
	DECLARE @OpportunityObjectiveId bigint
			
	
	INSERT INTO TOpportunityObjective (
		OpportunityId, 
		ObjectiveId, 
		ConcurrencyId)
		
	VALUES(
		@OpportunityId, 
		@ObjectiveId,
		1)

	SELECT @OpportunityObjectiveId = SCOPE_IDENTITY()
	
	INSERT INTO TOpportunityObjectiveAudit (
		OpportunityId, 
		ObjectiveId, 
		ConcurrencyId,
		OpportunityObjectiveId,
		StampAction,
    	StampDateTime,
    	StampUser)
	SELECT  
		OpportunityId, 
		ObjectiveId, 
		ConcurrencyId,
		OpportunityObjectiveId,
		'C',
    	GetDate(),
    	@StampUser
	FROM TOpportunityObjective
	WHERE OpportunityObjectiveId = @OpportunityObjectiveId
	EXEC SpRetrieveOpportunityObjectiveById @OpportunityObjectiveId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
