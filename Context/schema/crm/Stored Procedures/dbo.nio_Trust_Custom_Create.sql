SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.nio_Trust_Custom_Create
	@TrustName VARCHAR(250),
	@RefTrustTypeId BIGINT,
	@EstDate DATETIME,
	@ArchiveFG BIT = 0,
	@CreatedOn date = NULL, -- @P4
	@CreatedByUserId int = NULL, -- @P5
	@UpdatedOn date = NULL, -- @P6
	@UpdatedByUserId int = NULL, -- @P7
	@ConcurrencyId BIGINT = 1,
	@LEI NVARCHAR(20) = NULL,
	@LEIExpiryDate DATE = NULL,
	@RegistrationNumber varchar(50) = NULL,
    @RegistrationDate DATE = NULL,
	@IndClientId BIGINT,
	@CRMContactId BIGINT = NULL,
	@BoobyTrap INT = -999

AS

If IsNull(@BoobyTrap,0) <> -999
Begin
	Raiserror('Incorrect number of parameters', 16, 1)
	Return 100
End

-- Select @CRMContactId, @TenantId
DECLARE @TrustId Bigint
-- DECLARE @CRMContactId Bigint

INSERT INTO CRM..TTrust
(
	RefTrustTypeId,
	IndClientId,
	TrustName,
	EstDate,
	ArchiveFG,
	CreatedOn,
	CreatedByUserId,
	UpdatedOn,
	UpdatedByUserId,
	LEI,
	LEIExpiryDate,
	RegistrationNumber,
    RegistrationDate
)
VALUES
(
	@RefTrustTypeId,
	@IndClientId,
	@TrustName,
	@EstDate,
	@ArchiveFG,
	@CreatedOn,
	@CreatedByUserId,
	@UpdatedOn,
	@UpdatedByUserId,
	@LEI,
	@LEIExpiryDate,
	@RegistrationNumber,
    @RegistrationDate
)

SET @TrustId = SCOPE_IDENTITY()

-- I know this is bad
If IsNUll(@CRMContactId,0) = 0
Begin
	INSERT INTO CRM..TCRMContact
	( 
	  TrustId,
	  CorporateName,
	  IndClientId
	)
	VALUES
	( 
	  @TrustId,
	  @TrustName,
	  @IndClientId
	)

	SET @CRMContactId = SCOPE_IDENTITY()

End
Else
Begin
	Update 
		CRM..TCRMContact
	Set 
		TrustId = @TrustId,
		CorporateName = @TrustName
	Where 
		CRMContactId = @CRMContactId
End


Select @CRMContactId

GO
