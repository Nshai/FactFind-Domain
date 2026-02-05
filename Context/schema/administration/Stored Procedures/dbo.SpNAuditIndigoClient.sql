SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditIndigoClient]
	@StampUser varchar (255),
	@IndigoClientId bigint,
	@StampAction char(1)
AS

INSERT INTO TIndigoClientAudit 
( Identifier, Status, PrimaryContact, ContactId, 
		PhoneNumber, EmailAddress,AdminEmail, PrimaryGroupId, NetworkId, 
		SIB, MCCB, FSA, IOProductType, 
		ExpiryDate, AddressLine1, AddressLine2, AddressLine3, 
		AddressLine4, CityTown, County, Postcode, 
		Country, IsNetwork, SupportServiceId, FirmSize, 
		Specialism, OtherSpecialism, SupportLevel, EmailSupOptn, 
		SupportEmail, TelSupOptn, SupportTelephone, 
		SessionTimeout, LicenceType, MaxConUsers, MaxULAGCount, 
		UADRestriction, MaxULADCount, AdviserCountRestrict, MaxAdviserCount, 
		MaxFinancialPlanningUsers, EmailFormat, UserNameFormat, NTDomain, 
		IsIndependent, BrandDescriptor, ServiceLevel, HostingFg, 
		CaseLoggingOption, Guid, RefEnvironmentId, IsPortfolioConstructionProvider, 
		IsAuthorProvider, IsAtrProvider, MortgageBenchLicenceCount, ConcurrencyId, MaxOutlookExtensionUsers,
		MaxAdvisaCentaCoreUsers, MaxFeAnalyticsCoreUsers, MaxAdvisaCentaCorePlusLifetimePlannerUsers, MaxVoyantUsers,
		MaxAdvisaCentaFullUsers, MaxAdvisaCentaFullPlusLifetimePlannerUsers, MaxPensionFreedomPlannerUsers,
		IndigoClientId, LEI, RefTenantTypeId, StampAction, StampDateTime, StampUser) 
Select Identifier, Status, PrimaryContact, ContactId, 
		PhoneNumber, EmailAddress,AdminEmail, PrimaryGroupId, NetworkId, 
		SIB, MCCB, FSA, IOProductType, 
		ExpiryDate, AddressLine1, AddressLine2, AddressLine3, 
		AddressLine4, CityTown, County, Postcode, 
		Country, IsNetwork, SupportServiceId, FirmSize, 
		Specialism, OtherSpecialism, SupportLevel, EmailSupOptn, 
		SupportEmail, TelSupOptn, SupportTelephone, 
		SessionTimeout, LicenceType, MaxConUsers, MaxULAGCount, 
		UADRestriction, MaxULADCount, AdviserCountRestrict, MaxAdviserCount, 
		MaxFinancialPlanningUsers, EmailFormat, UserNameFormat, NTDomain, 
		IsIndependent, BrandDescriptor, ServiceLevel, HostingFg, 
		CaseLoggingOption, Guid, RefEnvironmentId, IsPortfolioConstructionProvider, 
		IsAuthorProvider, IsAtrProvider, MortgageBenchLicenceCount, ConcurrencyId, MaxOutlookExtensionUsers,
		MaxAdvisaCentaCoreUsers, MaxFeAnalyticsCoreUsers, MaxAdvisaCentaCorePlusLifetimePlannerUsers, MaxVoyantUsers,
		MaxAdvisaCentaFullUsers, MaxAdvisaCentaFullPlusLifetimePlannerUsers, MaxPensionFreedomPlannerUsers,
		IndigoClientId, LEI, RefTenantTypeId, @StampAction, GetDate(), @StampUser
FROM TIndigoClient
WHERE IndigoClientId = @IndigoClientId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
