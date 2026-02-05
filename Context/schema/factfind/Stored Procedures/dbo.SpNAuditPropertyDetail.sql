SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditPropertyDetail]
	@StampUser varchar (255),
	@PropertyDetailId bigint,
	@StampAction char(1)
AS

INSERT INTO TPropertyDetailAudit 
(ConcurrencyId, CRMContactId, CRMContactId2, Owner, RelatedAddressStoreId, AddressLine1, 
	AddressLine2, AddressLine3, AddressLine4, CityTown, RefCountyId, RefCountryId, 
	Postcode, IsCurrentResidentialAddress, HouseType, PropertyType, TenureType, LeaseholdEndsOn, PropertyStatus, Construction, 
	NumberOfBedrooms, YearBuilt, IsProspective,
	PropertyDetailId, StampAction, StampDateTime, StampUser,ConstructionNotes,RoofConstructionNotes,RoofConstructionType
	,IsNewBuild,NHBCCertificateCovered,OtherCertificateCovered,CertificateNotes,BuilderName, RefAdditionalPropertyDetailId, IsExLocalAuthority, IsOutbuildings,
	NumberOfOutbuildings)
SELECT  ConcurrencyId, CRMContactId, CRMContactId2, Owner, RelatedAddressStoreId, AddressLine1, 
	AddressLine2, AddressLine3, AddressLine4, CityTown, RefCountyId, RefCountryId, 
	Postcode, IsCurrentResidentialAddress, HouseType, PropertyType, TenureType, LeaseholdEndsOn, PropertyStatus, Construction, 
	NumberOfBedrooms, YearBuilt, IsProspective,
	PropertyDetailId, @StampAction, GetDate(), @StampUser,ConstructionNotes,RoofConstructionNotes,RoofConstructionType
	,IsNewBuild,NHBCCertificateCovered,OtherCertificateCovered,CertificateNotes,BuilderName, RefAdditionalPropertyDetailId, IsExLocalAuthority, IsOutbuildings,
	NumberOfOutbuildings
FROM TPropertyDetail
WHERE PropertyDetailId = @PropertyDetailId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
