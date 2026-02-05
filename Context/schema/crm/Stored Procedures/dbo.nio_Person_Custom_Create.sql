SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_Person_Custom_Create]
    @Title varchar(255) = NULL, -- @P0
    @FirstName varchar(255), -- @P1
    @MiddleName varchar(255) = NULL, -- @P2
    @LastName varchar(255), -- @P3
    @MaidenName varchar(255) = NULL, -- @P4
	@DOB DateTime = NULL, -- @P5
    @GenderType varchar(255) = NULL, -- @P6
	@NINumber varchar(255) = NULL, -- @P7
	@UKResident tinyint = NULL, -- @P8
	@ResidentIn varchar(50) = NULL, -- @P9
	@Salutation varchar(50) = NULL, -- @P10
	@MaritalStatus varchar(255) = NULL, -- @P11
	@MarriedOn datetime = NULL, -- @P12
	@Residency varchar(32) = NULL, -- @P13
	@UKDomicile bit = NULL, -- @P14
	@Domicile varchar(32) = NULL, -- @P15 
	@TaxCode varchar(12) = NULL, -- @P16
	@Nationality varchar(32) = NULL, -- @P17
	@Salary money = NULL,--@P18
	@IsSmoker varchar(10) = NULL, -- @P19
	@ConcurrencyId bigint = 1, -- @P20
    @TenantId bigint,  -- @P21
    @IsExpatriate bit=NULL, --@P22
	@HasSmokedInLast12Months bit=NULL, --@P23
	@IsInGoodHealth bit=NULL, --@P24
	@RefNationality bigint = null, -- @P25
	@IsPowerOfAttorneyGranted bit = NULL, -- @P26
	@AttorneyName varchar(255) = NULL, -- @P27
	@CreatedOn date = NULL, -- @P28
	@CreatedByUserId int = NULL, -- @P29
	@UpdatedOn date = NULL, -- @P30
	@UpdatedByUserId int = NULL, -- @P31
	@IsDisplayTitle bit = null, --@P32
	@MaritalStatusSince date = null, --@P33
	@CountryCodeOfResidence varchar(2) = NULL, -- @P34
	@CountryCodeOfDomicile varchar(2) = NULL, -- @P35
	@CRMContactId bigint = null, -- @P36
	@BoobyTrap int = null -- @P37,
AS

If IsNull(@BoobyTrap,0) <> -999
Begin
	Raiserror('Incorrect number of parameters', 16, 1)
	Return 100
End

-- Select @CRMContactId, @TenantId
DECLARE @PersonId Bigint
-- DECLARE @CRMContactId Bigint

INSERT INTO CRM..TPerson
(
	Title,
	FirstName,
	MiddleName,
	LastName,
	MaidenName,
	DOB,
	GenderType,
	NINumber,
	UKResident,
	ResidentIn, 
	Salutation,
	MaritalStatus, 
	MarriedOn,
	Residency, 
	UKDomicile,
	Domicile, 
	TaxCode, 
	Nationality, 
	IndClientId,
	Salary,
	IsSmoker,
	ConcurrencyId,
	Expatriate,
	HasSmokedInLast12Months,
	IsInGoodHealth,
	IsPowerOfAttorneyGranted,
	AttorneyName,
	CreatedOn,
	CreatedByUserId,
	UpdatedOn,
	UpdatedByUserId,
	IsDisplayTitle,
	MaritalStatusSince,
	CountryCodeOfResidence,
	CountryCodeOfDomicile
)
VALUES
(
	@Title,
	@FirstName,
	@MiddleName,
	@LastName,
	@MaidenName,
	@DOB,
	@GenderType,
	@NINumber,
	@UKResident,
	@ResidentIn, 
	@Salutation,
	@MaritalStatus, 
	@MarriedOn,
	@Residency, 
	@UKDomicile,
	@Domicile, 
	@TaxCode, 
	@Nationality, 
	@TenantId,
	@Salary,
	@IsSmoker,
	1,
	@IsExpatriate,
	@HasSmokedInLast12Months,
	@IsInGoodHealth,
	@IsPowerOfAttorneyGranted,
	@AttorneyName,
	@CreatedOn,
	@CreatedByUserId,
	@UpdatedOn,
	@UpdatedByUserId,
	@IsDisplayTitle,
	@MaritalStatusSince,
	@CountryCodeOfResidence,
	@CountryCodeOfDomicile
)

SET @PersonId = SCOPE_IDENTITY()

-- Exec SpNAuditPerson @StampUser, @PersonId, @StampAction

-- I know this is bad
If IsNUll(@CRMContactId,0) = 0
Begin
	INSERT INTO CRM..TCRMContact
	( 
	  PersonId,
	  FirstName,
	  LastName,
	  DOB,
	  IndClientId,
	  ConcurrencyId
	)
	VALUES
	( 
	  @PersonId,
	  @FirstName,
	  @LastName,
	  @DOB,
	  @TenantId,
	  1
	)

	SET @CRMContactId = SCOPE_IDENTITY()

End
Else
Begin
	Update CRM..TCRMContact
	Set PersonId = @PersonId,
	  FirstName = @FirstName,
	  LastName = @LastName,
	  DOB = @DOB
	Where CRMContactId = @CRMContactId
End


Select @CRMContactId


GO
