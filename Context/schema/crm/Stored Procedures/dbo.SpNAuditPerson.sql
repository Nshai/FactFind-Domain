SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditPerson]
	@StampUser varchar (255),
	@PersonId bigint,
	@StampAction char(1)
AS

INSERT INTO TPersonAudit ( 
	Title, FirstName, MiddleName, LastName, 
	MaidenName, DOB, GenderType, NINumber, 
	IsSmoker, UKResident, ResidentIn, Salutation, 
	RefSourceTypeId, IntroducerSource, MaritalStatus, MarriedOn, 
	Residency, UKDomicile, Domicile, TaxCode, 
	Nationality, ArchiveFG, IndClientId, Salary, 
	ConcurrencyId, Expatriate, RefNationalityId, HasSmokedInLast12Months, IsInGoodHealth, IsDisplayTitle,
	PersonId, StampAction, StampDateTime, StampUser, [MaritalStatusSince], [NationalClientIdentifier], 
	[CountryCodeOfResidence], [CountryCodeOfDomicile], IsPowerOfAttorneyGranted, InvitationSendDate,
	EverSmoked,HasVapedorUsedEcigarettesLast1Year,HaveUsedNicotineReplacementProductsLast1Year) 
SELECT
	Title, FirstName, MiddleName, LastName, 
	MaidenName, DOB, GenderType, NINumber, 
	IsSmoker, UKResident, ResidentIn, Salutation, 
	RefSourceTypeId, IntroducerSource, MaritalStatus, MarriedOn, 
	Residency, UKDomicile, Domicile, TaxCode, 
	Nationality, ArchiveFG, IndClientId, Salary, 
	ConcurrencyId, Expatriate, RefNationalityId, HasSmokedInLast12Months, IsInGoodHealth, IsDisplayTitle,
	PersonId, @StampAction, GetDate(), @StampUser, [MaritalStatusSince], [NationalClientIdentifier], 
	[CountryCodeOfResidence], [CountryCodeOfDomicile], IsPowerOfAttorneyGranted, InvitationSendDate,
	EverSmoked,HasVapedorUsedEcigarettesLast1Year,HaveUsedNicotineReplacementProductsLast1Year
FROM TPerson
WHERE PersonId = @PersonId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
