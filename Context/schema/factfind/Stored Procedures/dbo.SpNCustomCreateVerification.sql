SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreateVerification]
	@StampUser varchar(255), 
	@CRMContactId bigint,
	@MothersMaidenName varchar(50) = null,
	@ElectricityBillRef  varchar(50) = null,
	@DrivingLicenceSeen datetime = null,
	@DrivingLicenceRef varchar(50) = null,
	@MicroficheIssueDate datetime = null,
	@MicroficheNumber varchar(14) = null,
	@PassportSeen datetime = null,
	@CountryOfOrigin varchar(255) = null, 
	@PassportRef varchar(44) = null,
	@PassportExpiryDate datetime = null,
	@HomeVisit datetime = null,
	@PremisesEntered datetime = null,
	@MortgageStatementSeen datetime = null,
	@CouncilTaxBillSeen datetime = null,
	@UtilitiesBillSeen datetime = null,
	@IRTaxNotificationSeen datetime = null,
	@Comments text = null
AS

declare @VerificationId bigint

-- a verification record may have already been created from the fields on the person details page
if not exists (select 1 from CRM..TVerification where CRMContactId = @CRMContactId) begin
	insert into CRM..TVerification(
	CRMContactId,
	MothersMaidenName,
	ElectricityBillRef,
	DrivingLicenceSeen,
	DrivingLicenceRef,
	MicroficheIssueDate,
	MicroficheNumber,
	PassportSeen,
	CountryOfOrigin,
	PassportRef,
	PassportExpiryDate,
	HomeVisit,
	PremisesEntered,
	MortgageStatementSeen,
	CouncilTaxBillSeen,
	UtilitiesBillSeen,
	IRTaxNotificationSeen,
	Comments,
	ConcurrencyId)
	select 
	@CRMContactId,
	@MothersMaidenName,
	@ElectricityBillRef,
	@DrivingLicenceSeen,
	@DrivingLicenceRef,
	@MicroficheIssueDate,
	@MicroficheNumber,
	@PassportSeen,
	@CountryOfOrigin, 
	@PassportRef,
	@PassportExpiryDate,
	@HomeVisit,
	@PremisesEntered,
	@MortgageStatementSeen,
	@CouncilTaxBillSeen,
	@UtilitiesBillSeen,
	@IRTaxNotificationSeen,
	@Comments,
	1

	select @VerificationId = SCOPE_IDENTITY()

	insert into CRM..TVerificationAudit
	(
	
		PlaceOfBirth,
		MothersMaidenName,
		ElectricityBillRef,
		DrivingLicenceSeen,
		DrivingLicenceRef,
		MicroficheIssueDate,
		MicroficheNumber,
		PassportSeen,
		CountryOfOrigin,
		PassportRef,
		PassportExpiryDate,
		HomeVisit,
		PremisesEntered,
		MortgageStatementSeen,
		CouncilTaxBillSeen,
		UtilitiesBillSeen,
		IRTaxNotificationSeen,
		Comments,
		ConcurrencyId,
		VerificationId,
		StampAction,
		StampDateTime,
		StampUser,
		CRMContactId,
		DrivingLicenceExpiryDate
	)
	select 
		PlaceOfBirth,
		MothersMaidenName,
		ElectricityBillRef,
		DrivingLicenceSeen,
		DrivingLicenceRef,
		MicroficheIssueDate,
		MicroficheNumber,
		PassportSeen,
		CountryOfOrigin,
		PassportRef,
		PassportExpiryDate,
		HomeVisit,
		PremisesEntered,
		MortgageStatementSeen,
		CouncilTaxBillSeen,
		UtilitiesBillSeen,
		IRTaxNotificationSeen,
		Comments,
		ConcurrencyId,
		VerificationId,
		'C',
		getdate(),
		@StampUser,
		CRMContactId,
		DrivingLicenceExpiryDate
	from	CRM..TVerification
	where	verificationid = @verificationid
end
else begin

	insert into CRM..TVerificationAudit
	(
	PlaceOfBirth,
		MothersMaidenName,
		ElectricityBillRef,
		DrivingLicenceSeen,
		DrivingLicenceRef,
		MicroficheIssueDate,
		MicroficheNumber,
		PassportSeen,
		CountryOfOrigin,
		PassportRef,
		PassportExpiryDate,
		HomeVisit,
		PremisesEntered,
		MortgageStatementSeen,
		CouncilTaxBillSeen,
		UtilitiesBillSeen,
		IRTaxNotificationSeen,
		Comments,
		ConcurrencyId,
		VerificationId,
		StampAction,
		StampDateTime,
		StampUser,
		CRMContactId,
		DrivingLicenceExpiryDate
	)
	select 
		PlaceOfBirth,
		MothersMaidenName,
		ElectricityBillRef,
		DrivingLicenceSeen,
		DrivingLicenceRef,
		MicroficheIssueDate,
		MicroficheNumber,
		PassportSeen,
		CountryOfOrigin,
		PassportRef,
		PassportExpiryDate,
		HomeVisit,
		PremisesEntered,
		MortgageStatementSeen,
		CouncilTaxBillSeen,
		UtilitiesBillSeen,
		IRTaxNotificationSeen,
		Comments,
		ConcurrencyId,
		VerificationId,
		'U',
		getdate(),
		@StampUser,
		CRMContactId,
		DrivingLicenceExpiryDate
	from	CRM..TVerification
	where	CRMContactId = @CRMContactId

	update	CRM..TVerification
	set		ElectricityBillRef = @ElectricityBillRef,
			DrivingLicenceSeen = @DrivingLicenceSeen,
			DrivingLicenceRef = @DrivingLicenceRef,
			MicroficheIssueDate = @MicroficheIssueDate,
			MicroficheNumber = @MicroficheNumber,
			PassportSeen = @PassportSeen,
			CountryOfOrigin = @CountryOfOrigin,
			PassportRef = @PassportRef,
			PassportExpiryDate = @PassportExpiryDate,
			HomeVisit = @HomeVisit,
			PremisesEntered = @PremisesEntered,
			MortgageStatementSeen = @MortgageStatementSeen,
			CouncilTaxBillSeen = @CouncilTaxBillSeen,
			UtilitiesBillSeen = @UtilitiesBillSeen,
			IRTaxNotificationSeen = @IRTaxNotificationSeen,
			ConcurrencyId = ConcurrencyId + 1
	where	CRMContactId = @CRMContactId 

end
GO
