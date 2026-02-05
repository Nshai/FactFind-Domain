SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.nio_Corporate_Custom_Create
	@CorporateName VARCHAR(250),
	@BusinessType VARCHAR(2000) = NULL,
	@RefCorporateTypeId BIGINT = NULL,
	@CompanyRegNo VARCHAR(50) = NULL,
	@EstIncorpDate DATETIME = NULL,
	@YearEnd DATETIME = NULL, 
	@VatRegFg BIT = NULL,
	@VatRegNo VARCHAR(50) = NULL, 
	@CreatedOn date = NULL, -- @P8
	@CreatedByUserId int = NULL, -- @P9
	@UpdatedOn date = NULL, -- @P10
	@UpdatedByUserId int = NULL, -- @P11
	@ConcurrencyId BIGINT = 1,
	@LEI NVARCHAR(20) = NULL,
	@LEIExpiryDate DATE = NULL,
	@NINumber VARCHAR(50) = NULL,
	@IndClientId BIGINT,
	@CRMContactId BIGINT = NULL,
	@BoobyTrap INT = NULL,
	@BusinessRegistrationNumber VARCHAR(50) = NULL
AS

If IsNull(@BoobyTrap,0) <> -999
Begin
	Raiserror('Incorrect number of parameters', 16, 1)
	Return 100
End

-- Select @CRMContactId, @TenantId
DECLARE @CorporateId Bigint
-- DECLARE @CRMContactId Bigint

INSERT INTO CRM..TCorporate
(
	IndClientId,
	CorporateName,
	BusinessType,
	RefCorporateTypeId,
	CompanyRegNo,
	EstIncorpDate,
	YearEnd,
	VatRegFg,
	VatRegNo,
	CreatedOn,
	CreatedByUserId,
	UpdatedOn,
	UpdatedByUserId,
	LEI,
	LEIExpiryDate,
	BusinessRegistrationNumber,
	NINumber
)
VALUES
(
	@IndClientId,
	@CorporateName,
	@BusinessType,
	@RefCorporateTypeId,
	@CompanyRegNo,
	@EstIncorpDate,
	@YearEnd,
	@VatRegFg,
	@VatRegNo,
	@CreatedOn,
	@CreatedByUserId,
	@UpdatedOn,
	@UpdatedByUserId,
	@LEI,
	@LEIExpiryDate,
	@BusinessRegistrationNumber,
	@NINumber
)

SET @CorporateId = SCOPE_IDENTITY()

-- I know this is bad
If IsNUll(@CRMContactId,0) = 0
Begin
	INSERT INTO CRM..TCRMContact
	( 
	  CorporateId,
	  CorporateName,
	  IndClientId
	)
	VALUES
	( 
	  @CorporateId,
	  @CorporateName,
	  @IndClientId
	)

	SET @CRMContactId = SCOPE_IDENTITY()

End
Else
Begin
	Update 
		CRM..TCRMContact
	Set 
		CorporateId = @CorporateId,
		CorporateName = @CorporateName
	Where 
		CRMContactId = @CRMContactId
End


Select @CRMContactId
GO
