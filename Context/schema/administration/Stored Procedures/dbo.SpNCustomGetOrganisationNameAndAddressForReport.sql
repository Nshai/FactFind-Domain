SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomGetOrganisationNameAndAddressForReport]
	@ReportName varchar(255), 
	@AdviserCRMContactId bigint,
	@Default varchar(255),
	@IndigoClientId bigint
AS
DECLARE
	@UseOrganisation bit, @UseLegalEntity bit, @UseGroup bit, @UserId bigint,
	@OrganisationName varchar(255), @GroupId bigint, @IndigoCRMContactId bigint,
	@DefaultFax varchar(255), @DefaultPhone varchar(255), @DefaultEmail varchar(255), @FSARegNbr varchar(24)

SELECT @UserId = UserId FROM TUser u WHERE u.CRMContactId = @AdviserCRMContactId

SELECT 
	@UseOrganisation = UseOrganisationAddress, 
	@UseLegalEntity = UseLegalEntityAddress,
	@UseGroup = UseGroupAddress
FROM 
	TReportAddressConfiguration
WHERE 
	IndigoClientId = @IndigoClientId
	AND ReportName = @ReportName

IF ISNULL(@UseOrganisation, 0) = 0 AND ISNULL(@UseLegalEntity, 0) = 0 AND  ISNULL(@UseGroup, 0) = 0
BEGIN
	IF @Default = 'UseLegalEntityAddress'
		SELECT @UseOrganisation = 0, @UseLegalEntity = 1, @UseGroup = 0		
	ELSE IF @Default = 'UseGroupAddress'
		SELECT @UseOrganisation = 0, @UseLegalEntity = 0, @UseGroup = 1
	ELSE
		SELECT @UseOrganisation = 1, @UseLegalEntity = 0, @UseGroup = 0		
END

IF @UseOrganisation = 1 
	SELECT 
		i.Identifier AS OrganisationName,
		AddressLine1,
		AddressLine2,
		AddressLine3,
		AddressLine4,
		CityTown,
		county.CountyName AS County,
		Postcode,
		country.CountryName AS Country,
		PhoneNumber,
		EmailAddress,
		FSA
	FROM 
		TIndigoClient i
		LEFT JOIN crm..TRefCounty county ON county.RefCountyId = i.County
		LEFT JOIN crm..TRefCountry country ON country.RefCountryId = i.Country
	WHERE 
		IndigoClientId = @IndigoClientId
ELSE BEGIN
	IF @UseLegalEntity = 1
		-- Get LE details
		SELECT @GroupId = GroupId FROM FnGetLegalEntityForUser(@UserId)
	ELSE
		SELECT @GroupId = GroupId FROM TUser WHERE UserId = @UserId

	-- Get CRMContactId for group and the FSA number
	SELECT	@IndigoCRMContactId = CRMContactId
			, @FSARegNbr = FSARegNbr
	FROM	Administration..TGroup
	WHERE GroupId = @GroupId
	
	-- Get contact details.
	SELECT @DefaultFax = [Value] from CRM..TContact a where RefContactType = 'Fax' and DefaultFg = 1 and CRMContactId = @IndigoCRMContactId
	SELECT @DefaultPhone = [Value] from CRM..TContact a where RefContactType = 'Telephone' and DefaultFg = 1 and CRMContactId = @IndigoCRMContactId
	SELECT @DefaultEmail = [Value] FROM CRM..TContact WHERE RefContactType = 'E-Mail' AND DefaultFg = 1 AND CRMContactId = @IndigoCRMContactId

	SELECT 
		g.Identifier AS OrganisationName,
		ast.AddressLine1,
		ast.AddressLine2,
		ast.AddressLine3,
		ast.AddressLine4,
		ast.CityTown,
		county.CountyName AS County,
		ast.Postcode,
		country.CountryName AS Country,
		case when isnull(@DefaultPhone,'') = '' then isnull(i.PhoneNumber,'') else @DefaultPhone end as [PhoneNumber],
		isnull(@DefaultFax,'')as [Fax],
		case when isnull(@DefaultEmail,'') = '' then isnull(i.EmailAddress,'') else @DefaultEmail end as [EmailAddress],
		isnull(@FSARegNbr,'') as FSA
	FROM 
		TGroup g
		JOIN TIndigoClient i ON i.IndigoCLientId = g.IndigoClientId
		JOIN CRM..TCRMContact c ON g.CRMContactId = c.CRMContactId
		LEFT JOIN CRM..TAddress ad ON ad.CRMContactId = c.CRMContactId
		LEFT JOIN CRM..TAddressStore ast ON ast.AddressStoreId = ad.AddressStoreId
		LEFT JOIN crm..TRefCounty county ON county.RefCountyId = ast.RefCountyId
		LEFT JOIN crm..TRefCountry country ON country.RefCountryId = ast.RefCountryId
	WHERE 
		g.GroupId = @GroupId
END
GO
