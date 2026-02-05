SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditVerification]
	@StampUser varchar (255),
	@VerificationId bigint,
	@StampAction char(1)
AS

INSERT INTO TVerificationAudit 
( PlaceOfBirth,CountryOfBirth, MothersMaidenName, ElectricityBillSeen, ElectricityBillRef, DrivingLicenceSeen, 
		DrivingLicenceRef, MicroficheIssueDate, MicroficheNumber, PassportSeen, 
		CountryOfOrigin, PassportRef, PassportExpiryDate, HomeVisit, 
		PremisesEntered, MortgageStatementSeen, CouncilTaxBillSeen, UtilitiesBillSeen, UtilitiesBillRef,
		IRTaxNotificationSeen, Comments, ConcurrencyId, CRMContactId, 
		
	VerificationId, StampAction, StampDateTime, StampUser,DrivingLicenceExpiryDate, PractitionerId, WitnessPosition, WitnessedDate,
	[PlaceOfBirthOther], [BankStatementSeen], [FirearmOrShotgunCertificateExpiryDate], [FirearmOrShotgunCertificateRef],
	[FirearmOrShotgunCertificateSeen],[VerificationExpiryDate] ) 
Select PlaceOfBirth,CountryOfBirth, MothersMaidenName, ElectricityBillSeen, ElectricityBillRef, DrivingLicenceSeen, 
		DrivingLicenceRef, MicroficheIssueDate, MicroficheNumber, PassportSeen, 
		CountryOfOrigin, PassportRef, PassportExpiryDate, HomeVisit, 
		PremisesEntered, MortgageStatementSeen, CouncilTaxBillSeen, UtilitiesBillSeen, UtilitiesBillRef,
		IRTaxNotificationSeen, Comments, ConcurrencyId, CRMContactId, 
		
	VerificationId, @StampAction, GetDate(), @StampUser,DrivingLicenceExpiryDate, PractitionerId, WitnessPosition, WitnessedDate,
	[PlaceOfBirthOther], [BankStatementSeen], [FirearmOrShotgunCertificateExpiryDate], [FirearmOrShotgunCertificateRef],
	[FirearmOrShotgunCertificateSeen],[VerificationExpiryDate]
FROM TVerification
WHERE VerificationId = @VerificationId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
