SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditProfessionalContact]
	@StampUser varchar (255),
	@ProfessionalContactId bigint,
	@StampAction char(1)
AS

INSERT INTO TProfessionalContactAudit (
	CRMContactId, ContactType, ContactName, CompanyName,
	AddressLine1, AddressLine2, AddressLine3, AddressLine4,
	CityTown, County, PostCode, TelephoneNumber,
	FascimileNumber, MobileNumber, EmailAddress, ConcurrencyId,
	ProfessionalContactId, StampAction, StampDateTime, StampUser,
	[PermissionToContact], [IsSourceOfFunds], CountyCode
)
SELECT 
	CRMContactId, ContactType, ContactName, CompanyName,
	AddressLine1, AddressLine2, AddressLine3, AddressLine4,
	CityTown, County, PostCode, TelephoneNumber,
	FascimileNumber, MobileNumber, EmailAddress, ConcurrencyId,
	ProfessionalContactId, @StampAction, GetDate(), @StampUser,
	[PermissionToContact], [IsSourceOfFunds], CountyCode
FROM 
	TProfessionalContact
WHERE 
	ProfessionalContactId = @ProfessionalContactId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
