SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateFinancialPlanningSession]
	@StampUser varchar (255),
	@FinancialPlanningId bigint,
	@FactFindId bigint, 
	@CRMContactId bigint, 
	@Description varchar(50)  = 'Planning Session', 
	@Date datetime = NULL, 
	@RefFinancialPlanningSessionStatusId int = 1, 
	@UserId bigint, 	
	@OpportunityId bigint = NULL,
	@DocumentId bigint = NULL
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	IF @Date IS NULL SET @Date = getdate()
	
	DECLARE @FinancialPlanningSessionId bigint
			
	
	INSERT INTO TFinancialPlanningSession (
		FinancialPlanningId,
		FactFindId,		
		CRMContactId, 
		Description, 
		Date, 
		RefFinancialPlanningSessionStatusId, 
		UserId, 
		OpportunityId, 
		DocumentId,
		ConcurrencyId)
		
	VALUES(
		@FinancialPlanningId,
		@FactFindId,
		@CRMContactId, 
		@Description, 
		@Date, 
		@RefFinancialPlanningSessionStatusId, 
		@UserId, 
		@OpportunityId,
		@DocumentId,
		1)

	SELECT @FinancialPlanningSessionId = SCOPE_IDENTITY()
	
	INSERT INTO TFinancialPlanningSessionAudit (
		FinancialPlanningId,
		FactFindId,		
		CRMContactId, 
		Description, 
		Date, 
		RefFinancialPlanningSessionStatusId, 
		UserId, 
		OpportunityId, 
		DocumentId,
		ConcurrencyId,
		FinancialPlanningSessionId,
		StampAction,
    	StampDateTime,
    	StampUser)
	SELECT 
		FinancialPlanningId,
		FactFindId,		
		CRMContactId, 
		Description, 
		Date, 
		RefFinancialPlanningSessionStatusId, 
		UserId, 
		OpportunityId,
		DocumentId,
		ConcurrencyId,
		FinancialPlanningSessionId,
		'C',
    	GetDate(),
    	@StampUser
	FROM TFinancialPlanningSession
	WHERE FinancialPlanningSessionId = @FinancialPlanningSessionId
	EXEC SpRetrieveFinancialPlanningSessionById @FinancialPlanningSessionId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
