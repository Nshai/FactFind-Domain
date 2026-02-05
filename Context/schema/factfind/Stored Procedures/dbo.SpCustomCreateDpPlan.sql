SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomCreateDpPlan]
	@StampUser varchar (255),
	@CRMContactId bigint, 
	@AdviserId bigint, 
	@IndigoClientId bigint, 
	@PlanGuid uniqueidentifier = NULL, 
	@PlanXml text = NULL	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	IF @PlanGuid IS NULL SELECT @PlanGuid = NEWID()
	DECLARE @DpPlanId bigint
			
	
	INSERT INTO TDpPlan
	(CRMContactId, AdviserId, IndigoClientId, PlanGuid, PlanXml, ConcurrencyId)
	VALUES(@CRMContactId, @AdviserId, @IndigoClientId, @PlanGuid, @PlanXml, 1)

	SELECT @DpPlanId = SCOPE_IDENTITY()

	INSERT INTO TDpPlanAudit 
	(CRMContactId, AdviserId, IndigoClientId, PlanGuid, PlanXml, ConcurrencyId,
		DpPlanId, StampAction, StampDateTime, StampUser)
	SELECT  CRMContactId, AdviserId, IndigoClientId, PlanGuid, PlanXml, ConcurrencyId,
		DpPlanId, 'C', GetDate(), @StampUser
	FROM TDpPlan
	WHERE DpPlanId = @DpPlanId

	EXEC SpCustomRetrieveDpPlan @DpPlanId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)

GO
