SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
--exec SpCustomGetOrganisationNameAndAddressForReport 'BSS',1553053,'UseOrganisationAddress',99
CREATE procedure [dbo].[SpCustomGetOrganisationNameAndAddressForReport]
	@ReportName varchar(255), 
	@AdviserCRMContactId bigint,
	@Default varchar(255),
	@IndigoClientId bigint
as
DECLARE @UseOrganisation bit, @UseLegalEntity bit, @UseGroup bit,
	@UserId bigint, @OrganisationName varchar(255), @GroupId bigint, @IndigoCRMContactId bigint,
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

IF ISNULL(@UseOrganisation, 0) = 0 AND ISNULL(@UseLegalEntity, 0) = 0 AND ISNULL(@UseGroup, 0) = 0
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
		1 as tag,
		null as parent,	
		i.Identifier as [Address!1!OrganisationName],
		isnull(i.AddressLine1,'') as [Address!1!AddressLine1],
		isnull(i.AddressLine2,'') as [Address!1!AddressLine2],
		isnull(i.AddressLine3,'') as [Address!1!AddressLine3],
		isnull(i.AddressLine4,'') as [Address!1!AddressLine4],
		isnull(i.CityTown,'') as [Address!1!CityTown],
		isnull(county.CountyName,'') as [Address!1!County],
		isnull(i.Postcode,'') as [Address!1!Postcode],
		isnull(country.CountryName,'') as [Address!1!Country],
		isnull(i.PhoneNumber,'') as [Address!1!PhoneNumber],
		isnull(i.EmailAddress,'') as [Address!1!EmailAddress],
		isnull(i.FSA,'') as [Address!1!FSA]
	FROM 
		TIndigoClient i
		LEFT JOIN crm..TRefCounty county ON county.RefCountyId = i.County
		LEFT JOIN crm..TRefCountry country ON country.RefCountryId = i.Country
	WHERE IndigoClientId = @IndigoClientId	
	FOR XML EXPLICIT
ELSE BEGIN
	IF @UseLegalEntity = 1  
		-- Get LE details
		SELECT @GroupId = GroupId FROM FnGetLegalEntityForUser(@UserId)
	ELSE 
		-- Get Group details.
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
		1 as tag,
		null as parent,	
		g.Identifier AS [Address!1!OrganisationName],
		isnull(ast.AddressLine1,'') as [Address!1!AddressLine1],
		isnull(ast.AddressLine2,'') as [Address!1!AddressLine2],
		isnull(ast.AddressLine3,'') as [Address!1!AddressLine3],
		isnull(ast.AddressLine4,'') as [Address!1!AddressLine4],
		isnull(ast.CityTown,'') as [Address!1!CityTown],
		isnull(county.CountyName,'') as [Address!1!County],
		isnull(ast.Postcode,'') as [Address!1!Postcode],
		isnull(country.CountryName,'') as [Address!1!Country],
		case when isnull(@DefaultPhone,'') = '' then isnull(i.PhoneNumber,'') else @DefaultPhone end as [Address!1!PhoneNumber],
		isnull(@DefaultFax,'')as [Address!1!Fax],
		case when isnull(@DefaultEmail,'') = '' then isnull(i.EmailAddress,'') else @DefaultEmail end as [Address!1!EmailAddress],
		isnull(@FSARegNbr,'') as [Address!1!FSA]	
	FROM TGroup g
		JOIN TIndigoClient i ON i.IndigoCLientId = g.IndigoClientId
		JOIN CRM..TCRMContact c ON g.CRMContactId = c.CRMContactId
		LEFT JOIN CRM..TAddress ad ON ad.CRMContactId = c.CRMContactId
		LEFT JOIN CRM..TAddressStore ast ON ast.AddressStoreId = ad.AddressStoreId
		LEFT JOIN crm..TRefCounty county ON county.RefCountyId = ast.RefCountyId
		LEFT JOIN crm..TRefCountry country ON country.RefCountryId = ast.RefCountryId
	WHERE 
		g.GroupId = @GroupId	
	FOR XML EXPLICIT	
END
GO
