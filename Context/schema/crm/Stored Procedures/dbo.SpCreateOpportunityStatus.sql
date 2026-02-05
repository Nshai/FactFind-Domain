SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateOpportunityStatus]
	@StampUser varchar (255),
	@OpportunityStatusName varchar(255) , 
	@IndigoClientId bigint, 
	@InitialStatusFG bit = 0, 
	@ArchiveFG bit = 0, 
	@AutoCloseOpportunityFg bit = 0, 
	@OpportunityStatusTypeId bigint = 1	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	
	DECLARE @OpportunityStatusId bigint
			
	
	INSERT INTO TOpportunityStatus (
		OpportunityStatusName, 
		IndigoClientId, 
		InitialStatusFG, 
		ArchiveFG, 
		AutoCloseOpportunityFg, 
		OpportunityStatusTypeId, 
		ConcurrencyId)
		
	VALUES(
		@OpportunityStatusName, 
		@IndigoClientId, 
		@InitialStatusFG, 
		@ArchiveFG, 
		@AutoCloseOpportunityFg, 
		@OpportunityStatusTypeId,
		1)

	SELECT @OpportunityStatusId = SCOPE_IDENTITY()
	
	INSERT INTO TOpportunityStatusAudit (
		OpportunityStatusName, 
		IndigoClientId, 
		InitialStatusFG, 
		ArchiveFG, 
		AutoCloseOpportunityFg, 
		OpportunityStatusTypeId, 
		ConcurrencyId,
		OpportunityStatusId,
		StampAction,
    	StampDateTime,
    	StampUser)
	SELECT  
		OpportunityStatusName, 
		IndigoClientId, 
		InitialStatusFG, 
		ArchiveFG, 
		AutoCloseOpportunityFg, 
		OpportunityStatusTypeId, 
		ConcurrencyId,
		OpportunityStatusId,
		'C',
    	GetDate(),
    	@StampUser
	FROM TOpportunityStatus
	WHERE OpportunityStatusId = @OpportunityStatusId
	EXEC SpRetrieveOpportunityStatusById @OpportunityStatusId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
