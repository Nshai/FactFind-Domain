SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateSplitBasic]
	@StampUser varchar (255),
	@IndClientId bigint, 
	@PractitionerId bigint = NULL, 
	@PractitionerCRMContactId bigint = NULL, 
	@BandingTemplateId bigint = NULL, 
	@GroupingId bigint = NULL, 
	@GroupCRMContactId bigint = NULL, 
	@SplitPercent decimal, 
	@PaymentEntityId bigint, 
	@PractitionerFg bit = 0	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	
	DECLARE @SplitBasicId bigint
			
	
	INSERT INTO TSplitBasic (
		IndClientId, 
		PractitionerId, 
		PractitionerCRMContactId, 
		BandingTemplateId, 
		GroupingId, 
		GroupCRMContactId, 
		SplitPercent, 
		PaymentEntityId, 
		PractitionerFg, 
		ConcurrencyId)
		
	VALUES(
		@IndClientId, 
		@PractitionerId, 
		@PractitionerCRMContactId, 
		@BandingTemplateId, 
		@GroupingId, 
		@GroupCRMContactId, 
		@SplitPercent, 
		@PaymentEntityId, 
		@PractitionerFg,
		1)

	SELECT @SplitBasicId = SCOPE_IDENTITY()

	INSERT INTO TSplitBasicAudit (
		IndClientId, 
		PractitionerId, 
		PractitionerCRMContactId, 
		BandingTemplateId, 
		GroupingId, 
		GroupCRMContactId, 
		SplitPercent, 
		PaymentEntityId, 
		PractitionerFg, 
		ConcurrencyId,
		SplitBasicId,
		StampAction,
    	StampDateTime,
    	StampUser)
	SELECT  
		IndClientId, 
		PractitionerId, 
		PractitionerCRMContactId, 
		BandingTemplateId, 
		GroupingId, 
		GroupCRMContactId, 
		SplitPercent, 
		PaymentEntityId, 
		PractitionerFg, 
		ConcurrencyId,
		SplitBasicId,
		'C',
    	GetDate(),
    	@StampUser
	FROM TSplitBasic
	WHERE SplitBasicId = @SplitBasicId

	EXEC SpRetrieveSplitBasicById @SplitBasicId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
