SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateCreditNote]
	@StampUser varchar (255),
	@FeeId bigint = NULL, 
	@RetainerId bigint = NULL, 
	@ProvBreakId bigint = NULL, 
	@NetAmount money = NULL, 
	@VATAmount money = NULL, 
	@DateRaised datetime = NULL, 
	@SentToClientDate datetime = NULL, 
	@Description varchar(255)  = NULL, 
	@IndigoClientId bigint	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	
	DECLARE @CreditNoteId bigint	
	
	INSERT INTO TCreditNote (
		FeeId, 
		RetainerId, 
		ProvBreakId, 
		NetAmount, 
		VATAmount, 
		DateRaised, 
		SentToClientDate, 
		Description, 
		IndigoClientId, 
		ConcurrencyId)
		
	VALUES(
		@FeeId, 
		@RetainerId, 
		@ProvBreakId, 
		@NetAmount, 
		@VATAmount, 
		@DateRaised, 
		@SentToClientDate, 
		@Description, 
		@IndigoClientId,
		1)

	SELECT @CreditNoteId = SCOPE_IDENTITY()
	
	INSERT INTO TCreditNoteAudit (
		FeeId, 
		RetainerId, 
		ProvBreakId, 
		NetAmount, 
		VATAmount, 
		DateRaised, 
		SentToClientDate, 
		Description, 
		IndigoClientId, 
		SequentialRef, 
		ConcurrencyId,
		CreditNoteId,
		StampAction,
    	StampDateTime,
    	StampUser)
	SELECT  
		FeeId, 
		RetainerId, 
		ProvBreakId, 
		NetAmount, 
		VATAmount, 
		DateRaised, 
		SentToClientDate, 
		Description, 
		IndigoClientId, 
		SequentialRef, 
		ConcurrencyId,
		CreditNoteId,
		'C',
    	GetDate(),
    	@StampUser
	FROM TCreditNote
	WHERE CreditNoteId = @CreditNoteId
	EXEC SpRetrieveCreditNoteById @CreditNoteId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
