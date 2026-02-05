SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditPartnershipdetails]
	@StampUser varchar (255),
	@PartnershipdetailsId bigint,
	@StampAction char(1)
AS

INSERT INTO TPartnershipdetailsAudit 
( CRMContactId, Name, AddressLine1, AddressLine2, 
		AddressLine3, AddressLine4, CityTown, Postcode, 
		CountryCode, CountyCode, Smoker, DOB, PercentageInterest, 
		InGoodHealth, ConcurrencyId, 
	    PartnershipdetailsId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, Name, AddressLine1, AddressLine2, 
		AddressLine3, AddressLine4, CityTown, Postcode, 
		CountryCode, CountyCode, Smoker, DOB, PercentageInterest, 
		InGoodHealth, ConcurrencyId, 
	    PartnershipdetailsId, @StampAction, GetDate(), @StampUser
FROM TPartnershipdetails
WHERE PartnershipdetailsId = @PartnershipdetailsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
