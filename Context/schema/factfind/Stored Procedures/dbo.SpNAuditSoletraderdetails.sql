SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditSoletraderdetails]
	@StampUser varchar (255),
	@SoletraderdetailsId bigint,
	@StampAction char(1)
AS

INSERT INTO TSoletraderdetailsAudit 
( CRMContactId, Name, AddressLine1, AddressLine2, 
		AddressLine3, AddressLine4, CityTown, Postcode, 
		CountryCode, CountyCode, Smoker, DOB, hasFamilyMembers, 
		FamilyMemberName, FamilyMemberRelationship, FamilyMemberDuties, IncorporateYesNo, 
		Value, InGoodHealth, AnyoneNeedProtection, ConcurrencyId, 
		SoletraderdetailsId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, Name, AddressLine1, AddressLine2, 
		AddressLine3, AddressLine4, CityTown, Postcode, 
		CountryCode, CountyCode,Smoker, DOB, hasFamilyMembers, 
		FamilyMemberName, FamilyMemberRelationship, FamilyMemberDuties, IncorporateYesNo, 
		Value, InGoodHealth, AnyoneNeedProtection, ConcurrencyId, 
		SoletraderdetailsId, @StampAction, GetDate(), @StampUser
FROM TSoletraderdetails
WHERE SoletraderdetailsId = @SoletraderdetailsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
