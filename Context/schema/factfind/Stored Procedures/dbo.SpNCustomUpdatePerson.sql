SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomUpdatePerson]
    @StampUser varchar(255),
    @CRMContactId BIGINT = null, -- Not currently used
    @ConcurrencyId BIGINT, -- Not currently used
    @PersonId INT,
    @Title varchar(255) = null,
    @OtherTitle varchar(255) = null,
    @FirstName varchar(255) = null,
    @MiddleName varchar(255) = null,
    @LastName varchar(255) = null,
    @MaidenName varchar(255) = null,
    @DOB varchar(255) = null,
    @GenderType varchar(255) = null,
    @MaritalStatus varchar(255) = null,
    @NINumber varchar(50) = null,
    @UKDomicile bit = null,
    @UKResident bit = NULL,
    @CountryCodeOfDomicile varchar(2) = NULL,
    @CountryCodeOfResidence varchar(2) = NULL,
    @Expatriate bit = NULL,
    @RefNationalityId int = null,
    @IsSmoker bit = null,
    @IsInGoodHealth bit = null,
    @HasSmokedInLast12Months bit = null,
    @IsPowerOfAttorneyGranted bit = null,
    @AttorneyName  varchar(255) = null,
    @IsDisplayTitle bit = null,
    @Salutation varchar(50) =null,
    @MaritalStatusSince date = null,
    @HealthNotes varchar(5000) = null,
    @MedicalConditionNotes varchar(5000) = null,
    @PlaceOfBirth varchar(50) = null,
    @PlaceOfBirthOther varchar(255) = null,
    @CountryOfBirth varchar(2) = null,
    @HasOtherConsiderations bit = null,
    @OtherConsiderationsNotes varchar(500) = null,
    @EverSmoked bit = null,
    @HasVapedorUsedEcigarettesLast1Year bit = null,
    @HaveUsedNicotineReplacementProductsLast1Year bit = null
AS    
-- Declarations.
DECLARE @TenantId INT,
        @Nationality varchar(32);

-- Error if names are missing
IF @FirstName IS NULL OR @LastName IS NULL
    RAISERROR('Person Firstname and Surname are required.', 11, 1)

-- Audit
EXEC CRM..SpNAuditPerson @StampUser, @PersonId, 'U'

-- Check for other title.
IF @Title = 'Other' AND @OtherTitle IS NOT NULL
    SET @Title = @OtherTitle

IF @IsPowerOfAttorneyGranted IS NULL OR @IsPowerOfAttorneyGranted = 0
    SET @AttorneyName = NULL

-- Reset marital status since date if the information is uknown
IF @MaritalStatus = 'Unknown'
    SET @MaritalStatusSince = NULL

IF @IsInGoodHealth = 1
    SET @HealthNotes = NULL
    
IF @HasOtherConsiderations = 0
    SET @OtherConsiderationsNotes = NULL
    
SELECT @Nationality = [Name] FROM CRM..TRefNationality WHERE RefNationalityId = @RefNationalityId

--------------------------------------------------------
-- Update TPerson
--------------------------------------------------------
UPDATE CRM..TPerson 
SET    
    Title = @Title,
    FirstName = @FirstName,
    MiddleName = @MiddleName,
    LastName = @LastName,
    MaidenName = @MaidenName,
    DOB = @DOB,
    GenderType = @GenderType,
    MaritalStatus = @MaritalStatus,
    MaritalStatusSince = @MaritalStatusSince,
    NINumber = @NINumber,
    UKResident = @UKResident,
    UKDomicile = @UKDomicile,  
    CountryCodeOfResidence=@CountryCodeOfResidence,
    CountryCodeOfDomicile=@CountryCodeOfDomicile,  
    Expatriate = @Expatriate,
    RefNationalityId = @RefNationalityId,
    IsSmoker = CASE @IsSmoker WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
    IsInGoodHealth = @IsInGoodHealth,
    HasSmokedInLast12Months = @HasSmokedInLast12Months,
    IsPowerOfAttorneyGranted = @IsPowerOfAttorneyGranted,
    AttorneyName = @AttorneyName,
    IsDisplayTitle = @IsDisplayTitle,
    Salutation = @Salutation,
    ConcurrencyId = ConcurrencyId + 1,
    Nationality = @Nationality,
    EverSmoked = @EverSmoked,
    HasVapedorUsedEcigarettesLast1Year = @HasVapedorUsedEcigarettesLast1Year,
    HaveUsedNicotineReplacementProductsLast1Year = @HaveUsedNicotineReplacementProductsLast1Year
WHERE
    PersonId = @PersonId

--------------------------------------------------------
-- Update notes in TPersonExt
--------------------------------------------------------
DECLARE @PersonExtId int, @ExistingHealthNotes varchar(5000), @ExistingMedicalConditionNotes varchar(5000),
@ExistingHasOtherConsiderations bit, @ExistingOtherConsiderationsNotes varchar(500)

SELECT @PersonExtId = PersonExtId, @ExistingHealthNotes = HealthNotes, @ExistingMedicalConditionNotes = MedicalConditionNotes,
        @ExistingHasOtherConsiderations = HasOtherConsiderations, @ExistingOtherConsiderationsNotes = OtherConsiderationsNotes
FROM CRM..TPersonExt
WHERE PersonId = @PersonId

IF @PersonExtId IS NOT NULL BEGIN
    IF ISNULL(@HealthNotes, '') != ISNULL(@ExistingHealthNotes, '') OR ISNULL(@MedicalConditionNotes, '') != ISNULL(@ExistingMedicalConditionNotes, '') 
       OR ISNULL(CONVERT(varchar, @HasOtherConsiderations), '') != ISNULL(CONVERT(varchar, @ExistingHasOtherConsiderations), '') OR ISNULL(@OtherConsiderationsNotes, '') != ISNULL(@ExistingOtherConsiderationsNotes, '') BEGIN
        EXEC CRM..SpNAuditPersonExt @StampUser, @PersonExtId, 'U'

        UPDATE CRM..TPersonExt
        SET HealthNotes = @HealthNotes, MedicalConditionNotes = @MedicalConditionNotes,
            HasOtherConsiderations = @HasOtherConsiderations, OtherConsiderationsNotes = @OtherConsiderationsNotes
        WHERE PersonExtId = @PersonExtId
    END
END
ELSE IF (@HealthNotes IS NOT NULL) OR (@MedicalConditionNotes IS NOT NULL) OR (@HasOtherConsiderations IS NOT NULL) 
        OR (@OtherConsiderationsNotes IS NOT NULL) BEGIN
    INSERT INTO CRM..TPersonExt (PersonId, HealthNotes, MedicalConditionNotes, HasOtherConsiderations, OtherConsiderationsNotes)
    VALUES (@PersonId, @HealthNotes, @MedicalConditionNotes, @HasOtherConsiderations, @OtherConsiderationsNotes)

    SET @PersonExtId = SCOPE_IDENTITY()
    EXEC CRM..SpNAuditPersonExt @StampUser, @PersonExtId, 'C'
END

-- Update CRMContact table  
SELECT @CRMContactId = CRMContactId, @TenantId = IndClientId FROM CRM..TCRMContact WHERE PersonId = @PersonId  
  
IF EXISTS (SELECT 1 FROM CRM..TCRMContact WHERE CRMContactId = @CRMContactId AND (FirstName != @FirstName OR   
    LastName != @LastName OR ISNULL(CONVERT(varchar(24), DOB, 120),'') != ISNULL(CONVERT(varchar(24), @DOB, 120),''))) 
BEGIN  
    -- Audit    
    EXEC CRM..SpNAuditCRMContact @StampUser, @CRMContactId, 'U'
    -- Update
    UPDATE     
        CRM..TCRMContact     
    SET    
        FirstName = @FirstName,
        LastName = @LastName,
        DOB = @DOB,  
        ConcurrencyId = ConcurrencyId + 1  
    WHERE
        CRMContactId = @CRMContactId  
END

--------------------------------------------------------
-- Update Place of Birth information in TVerification
--------------------------------------------------------
DECLARE @VerificationId int, @ExistingCountryOfBirth varchar(2), @ExistingPlaceOfBirth varchar(50),@ExistingPlaceOfBirthOther varchar(255)
SELECT @VerificationId = VerificationId, @ExistingCountryOfBirth = CountryOfBirth, @ExistingPlaceOfBirth = PlaceOfBirth,@ExistingPlaceOfBirthOther = PlaceOfBirthOther
FROM CRM..TVerification
WHERE CRMContactId = @CRMContactId

IF @VerificationId IS NOT NULL BEGIN
    IF ISNULL(@CountryOfBirth, '') != ISNULL(@ExistingCountryOfBirth, '') OR ISNULL(@PlaceOfBirth, '') != ISNULL(@ExistingPlaceOfBirth, '') OR ISNULL(@PlaceOfBirthOther, '') != ISNULL(@ExistingPlaceOfBirthOther, '') BEGIN
        EXEC CRM..SpNAuditVerification @StampUser, @VerificationId, 'U'

        UPDATE CRM..TVerification
        SET CountryOfBirth = @CountryOfBirth, PlaceOfBirth = @PlaceOfBirth,PlaceOfBirthOther = @PlaceOfBirthOther
        WHERE VerificationId = @VerificationId
    END
END
ELSE IF ISNULL(@CountryOfBirth,'') != '' OR ISNULL(@PlaceOfBirth,'') != '' OR ISNULL(@PlaceOfBirthOther,'') != '' BEGIN
    INSERT INTO CRM..TVerification(CRMContactId, CountryOfBirth, PlaceOfBirth,PlaceOfBirthOther)
    VALUES (@CRMContactId, @CountryOfBirth, @PlaceOfBirth,@PlaceOfBirthOther)

    SET @VerificationId = SCOPE_IDENTITY()
    EXEC CRM..SpNAuditVerification @StampUser, @VerificationId, 'C'
END