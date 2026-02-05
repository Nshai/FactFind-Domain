SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomUpdateGeneralBusinessDetails]
@GeneralBusinessDetailsId bigint,
@CRMContactId bigint,
@CorporateName varchar(255)=NULL,
@TypeName varchar(255)=NULL,
@LdpTypeName varchar(255)=NULL,
@Date1stAppointment datetime=NULL,
@StampUser varchar(255),
@ConcurrencyId bigint,
@LEI varchar(20)=NULL,
@LEIExpiryDate datetime=NULL

AS
DECLARE @CorporateId bigint
DECLARE @RefCorporateTypeId bigint
DECLARE @SelectedTypeName varchar(255)
DECLARE @CorporateAdviceAreasId bigint

IF LEN(ISNULL(@TypeName,''))>0
begin
	SELECT @RefCorporateTypeId=RefCorporateTypeId FROM CRM..TRefCorporateType WHERE TypeName=@TypeName
end
IF LEN(ISNULL(@LdpTypeName,''))>0
begin
	SELECT @RefCorporateTypeId=RefCorporateTypeId FROM CRM..TRefCorporateType WHERE TypeName=@LdpTypeName
end

SELECT @CorporateId=CorporateId FROM CRM..TCRMContact WHERE CRMContactId=@CRMContactId

-- IF @TypeName IS NOT NULL
-- BEGIN
-- 	SELECT @RefCorporateTypeId=RefCorporateTypeId FROM CRM..TRefCorporateType WHERE TypeName=@SelectedTypeName
-- END

IF @Date1stAppointment IS NOT NULL
BEGIN
SELECT @CorporateAdviceAreasId=CorporateAdviceAreasId FROM FactFind..TCorporateAdviceAreas WHERE CRMContactId=@CRMContactId
IF ISNULL(@CorporateAdviceAreasId,0)>0
	BEGIN
		EXEC SpNAuditCorporateAdviceAreas @StampUser,@CorporateAdviceAreasId,'U'
		UPDATE TCorporateAdviceAreas SET DateOfFirstAppointment=@Date1stAppointment,ConcurrencyId=ConcurrencyId + 1 WHERE CorporateAdviceAreasId=@CorporateAdviceAreasId
	END
ELSE
	BEGIN
		INSERT TCorporateAdviceAreas(CRMContactId,DateOfFirstAppointment,ConcurrencyId)
		SELECT @CRMContactId,@Date1stAppointment,1
	
		SELECT @CorporateAdviceAreasId=SCOPE_IDENTITY()
		EXEC SpNAuditCorporateAdviceAreas @StampUser,@CorporateAdviceAreasId,'C'	
	END
END

IF @CorporateId IS NOT NULL
BEGIN
	INSERT CRM..TCorporateAudit
	(IndClientId,
	CorporateName,
	ArchiveFG,
	BusinessType,
	RefCorporateTypeId,
	CompanyRegNo,
	EstIncorpDate,
	YearEnd,
	VatRegFg,
	Extensible,
	VatRegNo,
	ConcurrencyId,
	CorporateId,
	StampAction,
	StampDateTime,
	StampUser,
	LEI,
	LEIExpiryDate)
	
	SELECT IndClientId,
	CorporateName,
	ArchiveFG,
	BusinessType,
	RefCorporateTypeId,
	CompanyRegNo,
	EstIncorpDate,
	YearEnd,
	VatRegFg,
	Extensible,
	VatRegNo,
	ConcurrencyId,
	CorporateId,
	'U',
	GETDATE(),
	@StampUser,
	LEI,
	LEIExpiryDate
	
	FROM CRM..TCorporate 	
	WHERE CorporateId=@CorporateId
	
	UPDATE CRM..TCorporate
	SET CorporateName=@CorporateName,RefCorporateTypeId=@RefCorporateTypeId,ConcurrencyId=ConcurrencyId + 1,LEI=@LEI,LEIExpiryDate=@LEIExpiryDate
	WHERE CorporateId=@CorporateId

	INSERT CRM..TCRMContactAudit
		(RefCRMContactStatusId,
		PersonId,
		CorporateId,
		TrustId,
		AdvisorRef,
		RefSourceOfClientId,
		SourceValue,
		Notes,
		ArchiveFg,
		LastName,
		FirstName,
		CorporateName,
		DOB,
		Postcode,
		OriginalAdviserCRMId,
		CurrentAdviserCRMId,
		CurrentAdviserName,
		CRMContactType,
		IndClientId,
		FactFindId,
		InternalContactFG,
		RefServiceStatusId,
		_ParentId,
		_ParentTable,
		_ParentDb,
		_OwnerId,
		MigrationRef,
		CreatedDate,
		ExternalReference,
		AdditionalRef,
		CampaignDataId,
		ConcurrencyId,
		CRMContactId,
		StampAction,
		StampDateTime,
		StampUser)

		SELECT RefCRMContactStatusId,
		PersonId,
		CorporateId,
		TrustId,
		AdvisorRef,
		RefSourceOfClientId,
		SourceValue,
		Notes,
		ArchiveFg,
		LastName,
		FirstName,
		CorporateName,
		DOB,
		Postcode,
		OriginalAdviserCRMId,
		CurrentAdviserCRMId,
		CurrentAdviserName,
		CRMContactType,
		IndClientId,
		FactFindId,
		InternalContactFG,
		RefServiceStatusId,
		_ParentId,
		_ParentTable,
		_ParentDb,
		_OwnerId,
		MigrationRef,
		CreatedDate,
		ExternalReference,
		AdditionalRef,
		CampaignDataId,
		ConcurrencyId,
		CRMContactId,
		'U',
		GETDATE(),
		@StampUser

		FROM CRM..TCRMContact WHERE CRMContactId=@CRMContactId

	UPDATE CRM..TCRMContact SET CorporateName=@CorporateName,ConcurrencyId=ConcurrencyId + 1
	WHERE CRMContactId=@CRMContactId


END
GO
