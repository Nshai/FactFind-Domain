SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateCRMContactDpaQuestions]
	@StampUser varchar (255),
	@CRMContactId bigint, 
	@Mail bit = 0, 
	@Telephone bit = 0, 
	@Email bit = 0, 
	@Sms bit = 0, 
	@OtherMail bit = 0, 
	@OtherTelephone bit = 0, 
	@OtherEmail bit = 0, 
	@OtherSms bit = 0	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	
	DECLARE @CRMContactDpaQuestionsId bigint
			
	
	INSERT INTO TCRMContactDpaQuestions (
		CRMContactId, 
		Mail, 
		Telephone, 
		Email, 
		Sms, 
		OtherMail, 
		OtherTelephone, 
		OtherEmail, 
		OtherSms, 
		ConcurrencyId)
		
	VALUES(
		@CRMContactId, 
		@Mail, 
		@Telephone, 
		@Email, 
		@Sms, 
		@OtherMail, 
		@OtherTelephone, 
		@OtherEmail, 
		@OtherSms,
		1)

	SELECT @CRMContactDpaQuestionsId = SCOPE_IDENTITY()

	INSERT INTO TCRMContactDpaQuestionsAudit (
		CRMContactId, 
		Mail, 
		Telephone, 
		Email, 
		Sms, 
		OtherMail, 
		OtherTelephone, 
		OtherEmail, 
		OtherSms, 
		ConcurrencyId,
		CRMContactDpaQuestionsId,
		StampAction,
    	StampDateTime,
    	StampUser)
	SELECT  
		CRMContactId, 
		Mail, 
		Telephone, 
		Email, 
		Sms, 
		OtherMail, 
		OtherTelephone, 
		OtherEmail, 
		OtherSms, 
		ConcurrencyId,
		CRMContactDpaQuestionsId,
		'C',
    	GetDate(),
    	@StampUser
	FROM TCRMContactDpaQuestions
	WHERE CRMContactDpaQuestionsId = @CRMContactDpaQuestionsId

	EXEC SpRetrieveCRMContactDpaQuestionsById @CRMContactDpaQuestionsId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)

GO
