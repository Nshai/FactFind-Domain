SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateCorporate]
	@StampUser varchar (255),
	@IndClientId bigint = NULL, 
	@CorporateName varchar(250)  = NULL, 
	@ArchiveFg tinyint = NULL, 
	@BusinessType varchar(2000)  = NULL, 
	@RefCorporateTypeId bigint = NULL, 
	@CompanyRegNo varchar(50)  = NULL, 
	@EstIncorpDate datetime = NULL, 
	@YearEnd datetime = NULL, 
	@VatRegFg tinyint = NULL, 
	@VatRegNo varchar(50)  = NULL	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	
	DECLARE @CorporateId bigint
			
	
	INSERT INTO TCorporate (
		IndClientId, 
		CorporateName, 
		ArchiveFg, 
		BusinessType, 
		RefCorporateTypeId, 
		CompanyRegNo, 
		EstIncorpDate, 
		YearEnd, 
		VatRegFg, 
		VatRegNo, 
		ConcurrencyId)
		
	VALUES(
		@IndClientId, 
		@CorporateName, 
		@ArchiveFg, 
		@BusinessType, 
		@RefCorporateTypeId, 
		@CompanyRegNo, 
		@EstIncorpDate, 
		@YearEnd, 
		@VatRegFg, 
		@VatRegNo,
		1)

	SELECT @CorporateId = SCOPE_IDENTITY()

	INSERT INTO TCorporateAudit (
		IndClientId, 
		CorporateName, 
		ArchiveFg, 
		BusinessType, 
		RefCorporateTypeId, 
		CompanyRegNo, 
		EstIncorpDate, 
		YearEnd, 
		VatRegFg, 
		VatRegNo, 
		ConcurrencyId,
		CorporateId,
		StampAction,
    	StampDateTime,
    	StampUser)
	SELECT  
		IndClientId, 
		CorporateName, 
		ArchiveFg, 
		BusinessType, 
		RefCorporateTypeId, 
		CompanyRegNo, 
		EstIncorpDate, 
		YearEnd, 
		VatRegFg, 
		VatRegNo, 
		ConcurrencyId,
		CorporateId,
		'C',
    	GetDate(),
    	@StampUser
	FROM TCorporate
	WHERE CorporateId = @CorporateId

	EXEC SpRetrieveCorporateById @CorporateId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
