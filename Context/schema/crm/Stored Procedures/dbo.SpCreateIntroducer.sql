SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateIntroducer]
	@StampUser varchar (255),
	@IndClientId bigint, 
	@CRMContactId bigint, 
	@AgreementDate datetime = NULL, 
	@RefIntroducerTypeId bigint, 
	@PractitionerId bigint = NULL, 
	@ArchiveFG bit = 0, 
	@Identifier varchar(50)  = NULL, 
	@UniqueIdentifier varchar(255)  = NULL	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	
	DECLARE @IntroducerId bigint
			
	
	INSERT INTO TIntroducer (
		IndClientId, 
		CRMContactId, 
		AgreementDate, 
		RefIntroducerTypeId, 
		PractitionerId, 
		ArchiveFG, 
		Identifier, 
		UniqueIdentifier, 
		ConcurrencyId)
		
	VALUES(
		@IndClientId, 
		@CRMContactId, 
		@AgreementDate, 
		@RefIntroducerTypeId, 
		@PractitionerId, 
		@ArchiveFG, 
		@Identifier, 
		@UniqueIdentifier,
		1)

	SELECT @IntroducerId = SCOPE_IDENTITY()

	INSERT INTO TIntroducerAudit (
		IndClientId, 
		CRMContactId, 
		AgreementDate, 
		RefIntroducerTypeId, 
		PractitionerId, 
		ArchiveFG, 
		Identifier, 
		UniqueIdentifier, 
		ConcurrencyId,
		IntroducerId,
		StampAction,
    	StampDateTime,
    	StampUser)
	SELECT  
		IndClientId, 
		CRMContactId, 
		AgreementDate, 
		RefIntroducerTypeId, 
		PractitionerId, 
		ArchiveFG, 
		Identifier, 
		UniqueIdentifier, 
		ConcurrencyId,
		IntroducerId,
		'C',
    	GetDate(),
    	@StampUser
	FROM TIntroducer
	WHERE IntroducerId = @IntroducerId

	EXEC SpRetrieveIntroducerById @IntroducerId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
